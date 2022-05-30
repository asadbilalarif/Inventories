using Inventories.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
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
            return View(AdjustmentList);
        }

        public ActionResult CreateAdjustment(int Id = 0)
        {
            ViewBag.Warehouse = DB.tblWarehouses.Where(x => x.isActive == true).ToList();

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
            DB.tblAdjustmentItems.RemoveRange(Data1);
            DB.tblAdjustments.Remove(Data);
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