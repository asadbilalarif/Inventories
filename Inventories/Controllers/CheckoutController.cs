using Inventories.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
    public class CheckoutController : Controller
    {
        // GET: Checkout
        InventoriesEntities DB = new InventoriesEntities();
        public ActionResult Checkouts(string Success, string Update, string Delete)
        {
            List<tblCheckout> CheckoutList = DB.tblCheckouts.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;
            return View(CheckoutList);
        }

        public ActionResult CreateCheckout(int Id = 0)
        {
            ViewBag.Warehouse = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
            ViewBag.Contact = DB.tblContacts.Where(x => x.isActive == true).ToList();

            tblCheckout Data = new tblCheckout();
            List<tblCheckoutItem> Data1 = new List<tblCheckoutItem>();
            if (Id > 0)
            {
                Data = DB.tblCheckouts.Where(x => x.CheckoutId == Id).FirstOrDefault();
                ViewBag.CheckoutNumber = Data.CheckoutNumber;
                ViewBag.tblCheckoutItem = DB.tblCheckoutItems.Where(x => x.CheckoutId == Id).ToList();
            }
            else
            {
                Data.CheckoutId = 0;
                Data.Contact = 0;
                Data.Warehouse = 0;
                Data.CheckoutDate = DateTime.Now;
                ViewBag.tblCheckoutItem = null;
                ViewBag.CheckoutNumber = DB.CheckoutNumber().SingleOrDefault();
            }
            return View(Data);
        }

        [HttpPost]
        public ActionResult CreateCheckout(tblCheckout[] HeadData, List<tblCheckoutItem> TailData)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblCheckout Data = new tblCheckout();
            string TNumber = HeadData[0].CheckoutNumber;
            if (HeadData.FirstOrDefault().CheckoutId == 0)
            {
                if (DB.tblCheckouts.Where(x => x.CheckoutNumber == TNumber).FirstOrDefault() == null)
                {
                    Data.CheckoutNumber = TNumber;
                }
                else
                {
                    Data.CheckoutNumber = DB.CheckoutNumber().SingleOrDefault();
                }

                Data.CheckoutDate = HeadData[0].CheckoutDate;
                Data.Contact = HeadData[0].Contact;
                Data.Warehouse = HeadData[0].Warehouse;
                Data.Reference = HeadData[0].Reference;
                Data.Details = HeadData[0].Details;
                Data.draft = HeadData[0].draft;
                Data.CreatedDate = DateTime.Now;
                Data.CreatedBy = UserId;
                var Path = DB.tblTempPaths.Where(s => s.UserId == UserId).FirstOrDefault();
                if (Path != null)
                {
                    Data.Attachment = Path.Path;

                }
                DB.tblCheckouts.Add(Data);
                DB.SaveChanges();

                if (Path != null)
                {
                    DB.tblTempPaths.Remove(Path);
                    DB.SaveChanges();
                }

                if (TailData == null)
                {
                    TailData = new List<tblCheckoutItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (tblCheckoutItem Item in TailData)
                {
                    if (First)
                    {
                        Item.CheckoutId = Data.CheckoutId;
                        Item.CreatedBy = UserId;
                        Item.CreatedDate = DateTime.Now;
                        DB.tblCheckoutItems.Add(Item);
                    }
                    else
                    {
                        First = true;
                    }

                }
                DB.SaveChanges();

                return Json(1);
            }
            else
            {
                int Id = HeadData.FirstOrDefault().CheckoutId;
                Data = DB.tblCheckouts.Select(r => r).Where(x => x.CheckoutId == Id).FirstOrDefault();

                Data.CheckoutNumber = HeadData[0].CheckoutNumber;
                Data.CheckoutDate = HeadData[0].CheckoutDate;
                Data.Contact = HeadData[0].Contact;
                Data.Warehouse = HeadData[0].Warehouse;
                Data.Reference = HeadData[0].Reference;
                Data.Details = HeadData[0].Details;
                Data.draft = HeadData[0].draft;
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


                List<tblCheckoutItem> TData;
                int CheckoutId = Data.CheckoutId;
                TData = DB.tblCheckoutItems.Select(r => r).Where(x => x.CheckoutId == CheckoutId).ToList();

                DB.tblCheckoutItems.RemoveRange(TData);
                DB.SaveChanges();

                if (TailData == null)
                {
                    TailData = new List<tblCheckoutItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (tblCheckoutItem Item in TailData)
                {
                    if (First)
                    {
                        Item.CheckoutId = Data.CheckoutId;
                        Item.CreatedBy = UserId;
                        Item.CreatedDate = DateTime.Now;
                        DB.tblCheckoutItems.Add(Item);
                    }
                    else
                    {
                        First = true;
                    }

                }
                DB.SaveChanges();
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
                //Data.TNumber = CheckoutNumber;
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
        public ActionResult DeleteCheckout(int Id)
        {
            tblCheckout Data = new tblCheckout();
            List<tblCheckoutItem> Data1 = new List<tblCheckoutItem>();
            Data = DB.tblCheckouts.Where(x => x.CheckoutId == Id).FirstOrDefault();
            Data1 = DB.tblCheckoutItems.Where(x => x.CheckoutId == Id).ToList();
            DB.tblCheckoutItems.RemoveRange(Data1);
            DB.tblCheckouts.Remove(Data);
            DB.SaveChanges();

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
    }
}