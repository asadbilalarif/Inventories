using Inventories.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
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
            return View(CheckinList);
        }

        public ActionResult CreateCheckin(int Id = 0)
        {
            ViewBag.Warehouse = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
            ViewBag.Contact = DB.tblContacts.Where(x => x.isActive == true).ToList();

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
                        DB.tblCheckinItems.Add(Item);
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
                int Id = HeadData.FirstOrDefault().CheckinId;
                Data = DB.tblCheckins.Select(r => r).Where(x => x.CheckinId == Id).FirstOrDefault();

                Data.CheckinNumber = HeadData[0].CheckinNumber;
                Data.CheckinDate = HeadData[0].CheckinDate;
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
            Data = DB.tblCheckins.Where(x => x.CheckinId == Id).FirstOrDefault();
            Data1 = DB.tblCheckinItems.Where(x => x.CheckinId == Id).ToList();
            DB.tblCheckinItems.RemoveRange(Data1);
            DB.tblCheckins.Remove(Data);
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