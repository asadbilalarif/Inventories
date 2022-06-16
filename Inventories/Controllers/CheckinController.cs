using Inventories.Hubs;
using Inventories.Models;
using Rotativa;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ZXing;
using ZXing.QrCode;
using static Inventories.FilterConfig;

namespace Inventories.Controllers
{
    [Authorize]
    [AuthorizeAction1FilterAttribute]
    public class CheckinController : Controller
    {
        // GET: Checkin
        InventoriesEntities DB = new InventoriesEntities();
        public ActionResult Checkins(string Success, string Update, string Delete)
        {
            List<tblCheckin> CheckinList = DB.tblCheckins.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;

            ViewBag.Access = Session["Access"];
            List<tblAccessLevel> AccessLevel = (List<tblAccessLevel>)ViewBag.Access;
            foreach (var item in AccessLevel)
            {
                if (item.MenuId == 14)
                {
                    ViewBag.CreateAccess = item.CreateAccess;
                    ViewBag.EditAccess = item.EditAccess;
                    ViewBag.DeleteAccess = item.DeleteAccess;
                }
            }

            return View(CheckinList);
        }

        public ActionResult CreateCheckin(int Id = 0)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            ViewBag.Contact = DB.tblContacts.Where(x => x.isActive == true).ToList();

            List<int?> WarehouseIds= DB.tblUserWarehouses.Where(x => x.UserId == UserId).Select(s => s.WarehouseId).ToList();
            int j = 1;
            string Ids = "  and WarehouseId in(";
            foreach (int item in WarehouseIds)
            {
                Ids += "'" + item + "' ";
                if(j==WarehouseIds.Count)
                {

                }
                else
                {
                    Ids += ",";
                    j += 1;
                }
            }
            Ids += ")";

            ViewBag.Warehouse = DB.WarehouseAccess(Ids).ToList();

            tblCheckin Data = new tblCheckin();
            List<tblCheckinItem> Data1 = new List<tblCheckinItem>();
            if (Id > 0)
            {
                Data = DB.tblCheckins.Where(x => x.CheckinId == Id).FirstOrDefault();
                ViewBag.CheckinNumber = Data.CheckinNumber;
                ViewBag.tblCheckinItem = DB.tblCheckinItems.Where(x => x.CheckinId == Id).ToList();
            }
            else
            {
                Data.CheckinId = 0;
                Data.Contact = 0;
                Data.Warehouse = 0;
                Data.CheckinDate = DateTime.Now;
                ViewBag.tblCheckinItem = null;
                ViewBag.CheckinNumber = DB.CheckinNumber().SingleOrDefault();
            }
            return View(Data);
        }

        [HttpPost]
        public ActionResult CreateCheckin(tblCheckin[] HeadData, List<tblCheckinItem> TailData)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblCheckin Data = new tblCheckin();
            string TNumber = HeadData[0].CheckinNumber;
            if (HeadData.FirstOrDefault().CheckinId == 0)
            {
                if (DB.tblCheckins.Where(x => x.CheckinNumber == TNumber).FirstOrDefault() == null)
                {
                    Data.CheckinNumber = TNumber;
                }
                else
                {
                    Data.CheckinNumber = DB.CheckinNumber().SingleOrDefault();
                }

                Data.CheckinDate = HeadData[0].CheckinDate;
                Data.Contact = HeadData[0].Contact;
                Data.Warehouse = HeadData[0].Warehouse;
                Data.Reference = HeadData[0].Reference;
                Data.Details = HeadData[0].Details;
                Data.draft = HeadData[0].draft;
                Data.QRCode = GenerateQRCode(Data.Reference, Data.CheckinNumber);
                Data.BarCode = GenerateBarCode(Data.Reference, Data.CheckinNumber);
                Data.CreatedDate = DateTime.Now;
                Data.CreatedBy = UserId;
                var Path = DB.tblTempPaths.Where(s => s.UserId == UserId).FirstOrDefault();
                if (Path != null)
                {
                    Data.Attachment = Path.Path;

                }
                DB.tblCheckins.Add(Data);
                DB.SaveChanges();

                if (Path != null)
                {
                    DB.tblTempPaths.Remove(Path);
                    DB.SaveChanges();
                }

                if (TailData == null)
                {
                    TailData = new List<tblCheckinItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (tblCheckinItem Item in TailData)
                {
                    if (First)
                    {
                        Item.CheckinId = Data.CheckinId;
                        Item.CreatedBy = UserId;
                        Item.CreatedDate = DateTime.Now;
                        Item.ItemUsedQuantity = 0;
                        Item.ItemNetQuantity = Item.ItemQuantity;
                        Item.CreatedDate = DateTime.Now;
                        DB.tblCheckinItems.Add(Item);
                    }
                    else
                    {
                        First = true;
                    }

                }
                DB.SaveChanges();
                NotificationHub.BroadcastData();
                return Json(1);
            }
            else
            {
                int Id = HeadData.FirstOrDefault().CheckinId;
                Data = DB.tblCheckins.Select(r => r).Where(x => x.CheckinId == Id).FirstOrDefault();

                Data.CheckinNumber = HeadData[0].CheckinNumber;
                Data.CheckinDate = HeadData[0].CheckinDate;
                Data.Contact = HeadData[0].Contact;
                Data.Warehouse = HeadData[0].Warehouse;
                Data.Reference = HeadData[0].Reference;
                Data.Details = HeadData[0].Details;
                Data.draft = HeadData[0].draft;
                Data.QRCode = GenerateQRCode(Data.Reference, Data.CheckinNumber);
                Data.BarCode = GenerateBarCode(Data.Reference, Data.CheckinNumber);
                Data.CreatedDate = DateTime.Now;
                Data.CreatedBy = UserId;
                Data.EditDate = DateTime.Now;
                Data.EditBy = UserId;

                var Path = DB.tblTempPaths.Where(s => s.UserId == UserId).FirstOrDefault();

                if (Path != null)
                {
                    Data.Attachment = Path.Path;

                }
                DB.Entry(Data);
                DB.SaveChanges();

                if (Path != null)
                {
                    DB.tblTempPaths.Remove(Path);
                    DB.SaveChanges();
                }


                List<tblCheckinItem> TData;
                int CheckinId = Data.CheckinId;
                TData = DB.tblCheckinItems.Select(r => r).Where(x => x.CheckinId == CheckinId).ToList();

                DB.tblCheckinItems.RemoveRange(TData);
                DB.SaveChanges();

                if (TailData == null)
                {
                    TailData = new List<tblCheckinItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (tblCheckinItem Item in TailData)
                {
                    if (First)
                    {
                        Item.CheckinId = Data.CheckinId;
                        Item.CreatedBy = UserId;
                        Item.CreatedDate = DateTime.Now;
                        DB.tblCheckinItems.Add(Item);
                    }
                    else
                    {
                        First = true;
                    }

                }
                DB.SaveChanges();
                NotificationHub.BroadcastData();
                return Json(2);
            }
        }

        [HttpPost]
        public ActionResult Create(HttpPostedFileBase file, int UserId)
        {

            int AddedRecord = 0;
            try
            {
                int Cou = DB.tblTempPaths.Count();
                if (Cou > 0)
                {
                    var PathObject = DB.tblTempPaths.Select(r => r).Where(r => r.UserId == UserId).FirstOrDefault();

                    DB.tblTempPaths.Remove(PathObject);
                    DB.SaveChanges();
                }

                string folder = Server.MapPath(string.Format("~/{0}/", "Uploading"));
                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                string path = Path.Combine(Server.MapPath("~/Uploading"), Path.GetFileName(file.FileName));

                file.SaveAs(path);
                path = Path.Combine("\\Uploading", Path.GetFileName(file.FileName));

                tblTempPath Data = new tblTempPath();
                //Data.TNumber = CheckinNumber;
                Data.Path = path;
                Data.UserId = UserId;
                DB.tblTempPaths.Add(Data);
                AddedRecord = DB.SaveChanges();
            }
            catch (Exception ex)
            {

                Console.WriteLine("Error" + ex.Message);
            }


            return Json(AddedRecord);
        }

        [HttpPost]
        public ActionResult DeleteCheckin(int Id)
        {
            tblCheckin Data = new tblCheckin();
            List<tblCheckinItem> Data1 = new List<tblCheckinItem>();
            tblCheckoutItem UpdateCheckinQty = new tblCheckoutItem();
            Data = DB.tblCheckins.Where(x => x.CheckinId == Id).FirstOrDefault();
            Data1 = DB.tblCheckinItems.Where(x => x.CheckinId == Id).ToList();
            bool Check = false;
            foreach (tblCheckinItem item in Data1)
            {
                //UpdateCheckinQty = new tblCheckoutItem();
                //UpdateCheckinQty = DB.tblCheckoutItems.Where(x => x.CheckinItemId == item.CheckinItemId).FirstOrDefault();
                if(item.ItemUsedQuantity>0)
                {
                    Check = true;
                    break;
                }
                //if(UpdateCheckinQty!=null)
                //{
                    //Check = true;
                    //break;
                //}
            }
            if(Check==false)
            {
                tblCheckin Obj = DB.tblCheckins.Where(x => x.CheckinId == Id).FirstOrDefault();
                string QRPath = Obj.QRCode;
                string BarPath = Obj.BarCode;
                
                DB.tblCheckinItems.RemoveRange(Data1);
                DB.tblCheckins.Remove(Data);
                DB.SaveChanges();
                bool exists1 = (System.IO.File.Exists(Server.MapPath(QRPath)));
                if (exists1)
                {
                    System.IO.File.Delete(Server.MapPath(QRPath));

                }
                exists1 = (System.IO.File.Exists(Server.MapPath(BarPath)));
                if (exists1)
                {
                    System.IO.File.Delete(Server.MapPath(BarPath));

                }
                NotificationHub.BroadcastData();
            }
            else
            {
                return Json(2);
            }

            return Json(1);
        }

        public JsonResult GetSearchValue(string search)
        {
            List<tblItem> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.tblItems.Where(x => x.Name.StartsWith(search)).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return new JsonResult { Data = allsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
        }

        
        public ActionResult ViewCheckin(int Id)
        {
            List<CheckinViewData_Result2> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.CheckinViewData(Id).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View(allsearch);
        }

        public ActionResult ViewCheckinPDF(int Id)
        {
            List<CheckinViewData_Result2> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.CheckinViewData(Id).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View(allsearch);
        }
        public ActionResult PrintCheckinViewDataToPdf(int Id)
        {
            return new ActionAsPdf("ViewCheckinPDF", new { Id = Id })
            {
                FileName = "Checkin_Pdf.pdf"
            };
        }


        private string GenerateQRCode(string qrcodeText, string Name)
        {
            string folderPath = "~/Uploading/QRCode/";
            string imagePath = "/Uploading/QRCode/" + Name + ".jpg";
            // If the directory doesn't exist then create it.
            if (!Directory.Exists(Server.MapPath(folderPath)))
            {
                Directory.CreateDirectory(Server.MapPath(folderPath));
            }
            bool exists1 = (System.IO.File.Exists(Server.MapPath(imagePath)));
            if (!exists1)
            {
                System.IO.File.Delete(Server.MapPath(imagePath));

            }
            var width = 70; // width of the Qr Code
            var height = 70; // height of the Qr Code
            var margin = 0;
            var barcodeWriter = new BarcodeWriter();
            barcodeWriter.Format = BarcodeFormat.QR_CODE;
            barcodeWriter.Options = new QrCodeEncodingOptions
            {
                Height = height,
                Width = width,
                Margin = margin,
            };
            var result = barcodeWriter.Write(qrcodeText);

            string barcodePath = Server.MapPath(imagePath);
            var barcodeBitmap = new Bitmap(result);
            using (MemoryStream memory = new MemoryStream())
            {
                using (FileStream fs = new FileStream(barcodePath, FileMode.Create, FileAccess.ReadWrite))
                {
                    barcodeBitmap.Save(memory, ImageFormat.Jpeg);
                    byte[] bytes = memory.ToArray();
                    fs.Write(bytes, 0, bytes.Length);
                }
            }
            return imagePath;
        }


        private string GenerateBarCode(string qrcodeText, string Name)
        {
            string folderPath = "~/Uploading/BarCode/";
            string imagePath = "/Uploading/BarCode/" + Name + ".jpg";
            // If the directory doesn't exist then create it.
            if (!Directory.Exists(Server.MapPath(folderPath)))
            {
                Directory.CreateDirectory(Server.MapPath(folderPath));
            }
            bool exists1 = (System.IO.File.Exists(Server.MapPath(imagePath)));
            if (!exists1)
            {
                System.IO.File.Delete(Server.MapPath(imagePath));

            }
            var width = 70; // width of the Qr Code
            var height = 70; // height of the Qr Code
            var margin = 0;
            var barcodeWriter = new BarcodeWriter();
            barcodeWriter.Format = BarcodeFormat.CODE_128;
            //barcodeWriter.Options.PureBarcode = true;
            barcodeWriter.Options = new QrCodeEncodingOptions
            {
                Height = height,
                Width = width,
                Margin = margin,
                PureBarcode=true
            };
            var result = barcodeWriter.Write(qrcodeText);

            string barcodePath = Server.MapPath(imagePath);
            var barcodeBitmap = new Bitmap(result);
            using (MemoryStream memory = new MemoryStream())
            {
                using (FileStream fs = new FileStream(barcodePath, FileMode.Create, FileAccess.ReadWrite))
                {
                    barcodeBitmap.Save(memory, ImageFormat.Jpeg);
                    byte[] bytes = memory.ToArray();
                    fs.Write(bytes, 0, bytes.Length);
                }
            }
            return imagePath;
        }
    }

}