using Inventories.Hubs;
using Inventories.Models;
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
    public class AdjustmentController : Controller
    {
        // GET: Adjustment
        InventoriesEntities DB = new InventoriesEntities();
        public ActionResult Adjustments(string Success, string Update, string Delete)
        {
            List<tblAdjustment> AdjustmentList = DB.tblAdjustments.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;

            ViewBag.Access = Session["Access"];
            List<tblAccessLevel> AccessLevel = (List<tblAccessLevel>)ViewBag.Access;
            foreach (var item in AccessLevel)
            {
                if (item.MenuId == 18)
                {
                    ViewBag.CreateAccess = item.CreateAccess;
                    ViewBag.EditAccess = item.EditAccess;
                    ViewBag.DeleteAccess = item.DeleteAccess;
                }
            }

            return View(AdjustmentList);
        }

        public ActionResult CreateAdjustment(int Id = 0)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);

            List<int?> WarehouseIds = DB.tblUserWarehouses.Where(x => x.UserId == UserId).Select(s => s.WarehouseId).ToList();

            int j = 1;
            string Ids = "  and WarehouseId in(";
            foreach (int item in WarehouseIds)
            {
                Ids += "'" + item + "' ";
                if (j == WarehouseIds.Count)
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

            tblAdjustment Data = new tblAdjustment();
            List<tblAdjustmentItem> Data1 = new List<tblAdjustmentItem>();
            if (Id > 0)
            {
                Data = DB.tblAdjustments.Where(x => x.AdjustmentId == Id).FirstOrDefault();
                ViewBag.AdjustmentNumber = Data.AdjustmentNumber;
                ViewBag.tblAdjustmentItem = DB.tblAdjustmentItems.Where(x => x.AdjustmentId == Id).ToList();
            }
            else
            {
                Data.AdjustmentId = 0;
                Data.Type = "";
                Data.Warehouse = 0;
                Data.AdjustmentDate = DateTime.Now;
                ViewBag.tblAdjustmentItem = null;
                ViewBag.AdjustmentNumber = DB.AdjustmentNumber().SingleOrDefault();
            }
            return View(Data);
        }

        [HttpPost]
        public ActionResult CreateAdjustment(tblAdjustment[] HeadData, List<tblAdjustmentItem> TailData)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblAdjustment Data = new tblAdjustment();
            string TNumber = HeadData[0].AdjustmentNumber;
            if (HeadData.FirstOrDefault().AdjustmentId == 0)
            {
                if (DB.tblAdjustments.Where(x => x.AdjustmentNumber == TNumber).FirstOrDefault() == null)
                {
                    Data.AdjustmentNumber = TNumber;
                }
                else
                {
                    Data.AdjustmentNumber = DB.AdjustmentNumber().SingleOrDefault();
                }

                Data.AdjustmentDate = HeadData[0].AdjustmentDate;
                Data.Type = HeadData[0].Type;
                Data.Warehouse = HeadData[0].Warehouse;
                Data.Reference = HeadData[0].Reference;
                Data.Details = HeadData[0].Details;
                Data.draft = HeadData[0].draft;
                Data.QRCode = GenerateQRCode(Data.Reference, Data.AdjustmentNumber);
                Data.BarCode = GenerateBarCode(Data.Reference, Data.AdjustmentNumber);
                Data.CreatedDate = DateTime.Now;
                Data.CreatedBy = UserId;
                var Path = DB.tblTempPaths.Where(s => s.UserId == UserId).FirstOrDefault();
                if (Path != null)
                {
                    Data.Attachment = Path.Path;

                }
                DB.tblAdjustments.Add(Data);
                DB.SaveChanges();

                if (Path != null)
                {
                    DB.tblTempPaths.Remove(Path);
                    DB.SaveChanges();
                }

                if (TailData == null)
                {
                    TailData = new List<tblAdjustmentItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (tblAdjustmentItem Item in TailData)
                {
                    if (First)
                    {
                        Item.AdjustmentId = Data.AdjustmentId;
                        Item.CreatedBy = UserId;
                        Item.CreatedDate = DateTime.Now;
                        Item.ItemUsedQuantity = 0;
                        Item.ItemNetQuantity = Item.ItemQuantity;
                        DB.tblAdjustmentItems.Add(Item);
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
                int Id = HeadData.FirstOrDefault().AdjustmentId;
                Data = DB.tblAdjustments.Select(r => r).Where(x => x.AdjustmentId == Id).FirstOrDefault();

                Data.AdjustmentNumber = HeadData[0].AdjustmentNumber;
                Data.AdjustmentDate = HeadData[0].AdjustmentDate;
                Data.Type = HeadData[0].Type;
                Data.Warehouse = HeadData[0].Warehouse;
                Data.Reference = HeadData[0].Reference;
                Data.Details = HeadData[0].Details;
                Data.draft = HeadData[0].draft;
                Data.QRCode = GenerateQRCode(Data.Reference, Data.AdjustmentNumber);
                Data.BarCode = GenerateBarCode(Data.Reference, Data.AdjustmentNumber);
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


                List<tblAdjustmentItem> TData;
                int AdjustmentId = Data.AdjustmentId;
                TData = DB.tblAdjustmentItems.Select(r => r).Where(x => x.AdjustmentId == AdjustmentId).ToList();

                DB.tblAdjustmentItems.RemoveRange(TData);
                DB.SaveChanges();

                if (TailData == null)
                {
                    TailData = new List<tblAdjustmentItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (tblAdjustmentItem Item in TailData)
                {
                    if (First)
                    {
                        Item.AdjustmentId = Data.AdjustmentId;
                        Item.CreatedBy = UserId;
                        Item.CreatedDate = DateTime.Now;
                        DB.tblAdjustmentItems.Add(Item);
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
                //Data.TNumber = AdjustmentNumber;
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
        public ActionResult DeleteAdjustment(int Id)
        {
            tblAdjustment Data = new tblAdjustment();
            List<tblAdjustmentItem> Data1 = new List<tblAdjustmentItem>();
            Data = DB.tblAdjustments.Where(x => x.AdjustmentId == Id).FirstOrDefault();
            Data1 = DB.tblAdjustmentItems.Where(x => x.AdjustmentId == Id).ToList();
            tblAdjustment Obj = DB.tblAdjustments.Where(x => x.AdjustmentId == Id).FirstOrDefault();
            string QRPath = Obj.QRCode;
            string BarPath = Obj.BarCode;
            DB.tblAdjustmentItems.RemoveRange(Data1);
            DB.tblAdjustments.Remove(Data);
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

        public ActionResult ViewAdjustment(int Id)
        {
            List<AdjustmentViewData_Result> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.AdjustmentViewData(Id).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View(allsearch);
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
                PureBarcode = true
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