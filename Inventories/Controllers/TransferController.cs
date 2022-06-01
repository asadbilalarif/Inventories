using Inventories.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
    [Authorize]
    public class TransferController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        // GET: Transfer
        public ActionResult Transfers(string Success, string Update, string Delete)
        {
            List<tblTransfer> TransferList = DB.tblTransfers.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;
            return View(TransferList);
        }


        public ActionResult CreateTransfer(int Id = 0)
        {
            ViewBag.Warehouse = DB.tblWarehouses.Where(x => x.isActive == true).ToList();

            tblTransfer Data = new tblTransfer();
            List<tblTransferItem> Data1 = new List<tblTransferItem>();
            try
            {
                if (Id > 0)
                {
                    Data = DB.tblTransfers.Where(x => x.TransferId == Id).FirstOrDefault();
                    //List<tblTransferItem> Cast = ViewBag.tblTransferItems;
                    // List<int?> CatIds = Cast.Select(s => s.CategoryId).ToList();
                    //ViewBag.CategoryNames = DB.tblCategories.Where(s => CatIds.Contains(s.CategoryID)).Select(s=>s.CategoryName).ToList();
                    ViewBag.TransferNumber = Data.TransferNumber;
                    ViewBag.tblTransferItem = DB.tblTransferItems.Where(x => x.TransferId == Id).ToList();
                }
                else
                {
                    Data.TransferId = 0;
                    Data.FromWarehouse = 0;
                    Data.ToWarehouse = 0;
                    Data.TransferDate = DateTime.Now;
                    ViewBag.tblTransferItem = null;
                    ViewBag.TransferNumber = DB.TransfrNumber().SingleOrDefault();
                }
                return View(Data);
            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }
            return View(Data);
        }

        [HttpPost]
        public ActionResult CreateTransfer(tblTransfer[] HeadData, List<tblTransferItem> TailData)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblTransfer Data = new tblTransfer();
            tblCheckinItem Update = new tblCheckinItem();
            tblAdjustmentItem AUpdate = new tblAdjustmentItem();
            
            string TNumber = HeadData[0].TransferNumber;
            if (HeadData.FirstOrDefault().TransferId == 0)
            {
                if(DB.tblTransfers.Where(x=>x.TransferNumber== TNumber).FirstOrDefault()==null)
                {
                    Data.TransferNumber = TNumber;
                }
                else
                {
                    Data.TransferNumber = DB.TransfrNumber().SingleOrDefault();
                }
               
                Data.TransferDate = HeadData[0].TransferDate;
                Data.FromWarehouse = HeadData[0].FromWarehouse;
                Data.ToWarehouse = HeadData[0].ToWarehouse;
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
                DB.tblTransfers.Add(Data);
                DB.SaveChanges();

                if (Path != null)
                {
                    DB.tblTempPaths.Remove(Path);
                    DB.SaveChanges();
                }

                if (TailData == null)
                {
                    TailData = new List<tblTransferItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (tblTransferItem Item in TailData)
                {
                    if (First)
                    {
                        Update = new tblCheckinItem();
                        AUpdate = new tblAdjustmentItem();
                        Item.TransferId = Data.TransferId;
                        Item.CreatedBy = UserId;
                        Item.CreatedDate = DateTime.Now;
                        Item.ItemUsedQuantity = 0;
                        Item.ItemNetQuantity = Item.ItemQuantity;
                        if (Item.VNumber[0] == 'C')
                        {
                            Update = DB.tblCheckinItems.Where(x => x.CheckinItemId == Item.CheckinItemId).FirstOrDefault();
                            Update.ItemUsedQuantity = Update.ItemUsedQuantity + Item.ItemQuantity;
                            Update.ItemNetQuantity = Update.ItemQuantity - Update.ItemUsedQuantity;
                            DB.Entry(Update);
                            DB.SaveChanges();
                        }
                        if (Item.VNumber[0] == 'A')
                        {
                            AUpdate = DB.tblAdjustmentItems.Where(x => x.AdjustmentItemId == Item.CheckinItemId).FirstOrDefault();
                            AUpdate.ItemUsedQuantity = AUpdate.ItemUsedQuantity + Item.ItemQuantity;
                            AUpdate.ItemNetQuantity = AUpdate.ItemQuantity - AUpdate.ItemUsedQuantity;
                            DB.Entry(AUpdate);
                            DB.SaveChanges();
                        }
                        DB.tblTransferItems.Add(Item);
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
                int Id = HeadData.FirstOrDefault().TransferId;
                Data = DB.tblTransfers.Select(r => r).Where(x => x.TransferId == Id).FirstOrDefault();

                Data.TransferNumber = HeadData[0].TransferNumber;
                Data.TransferDate = HeadData[0].TransferDate;
                Data.FromWarehouse = HeadData[0].FromWarehouse;
                Data.ToWarehouse = HeadData[0].ToWarehouse;
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


                List<tblTransferItem> TData;
                int TransferId = Data.TransferId;
                TData = DB.tblTransferItems.Select(r => r).Where(x => x.TransferId == TransferId).ToList();

                DB.tblTransferItems.RemoveRange(TData);
                DB.SaveChanges();

                if (TailData == null)
                {
                    TailData = new List<tblTransferItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (tblTransferItem Item in TailData)
                {
                    if (First)
                    {
                        Item.TransferId = Data.TransferId;
                        Item.CreatedBy = UserId;
                        Item.CreatedDate = DateTime.Now;
                        DB.tblTransferItems.Add(Item);
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
                //Data.TNumber = TransferNumber;
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
        public ActionResult DeleteTransfer(int Id)
        {
            tblTransfer Data = new tblTransfer();
            List<tblTransferItem> Data1 = new List<tblTransferItem>();
            Data = DB.tblTransfers.Where(x => x.TransferId == Id).FirstOrDefault();
            Data1 = DB.tblTransferItems.Where(x => x.TransferId == Id).ToList();
            tblCheckinItem Update = new tblCheckinItem();
            tblAdjustmentItem AUpdate = new tblAdjustmentItem();
            bool Check = false;
            foreach (tblTransferItem item in Data1)
            {
                if (item.ItemUsedQuantity > 0)
                {
                    Check = true;
                    break;
                }
                
            }
            if (Check == false)
            {
                foreach (tblTransferItem item in Data1)
                {
                    Update = new tblCheckinItem();
                    AUpdate = new tblAdjustmentItem();
                    if (item.VNumber[0] == 'C')
                    {
                        Update = DB.tblCheckinItems.Where(x => x.CheckinItemId == item.CheckinItemId).FirstOrDefault();
                        Update.ItemUsedQuantity -= item.ItemQuantity;
                        Update.ItemNetQuantity = Update.ItemQuantity - Update.ItemUsedQuantity;
                        DB.Entry(Update);
                        DB.SaveChanges();
                    }
                    if (item.VNumber[0] == 'A')
                    {
                        AUpdate = DB.tblAdjustmentItems.Where(x => x.AdjustmentItemId == item.CheckinItemId).FirstOrDefault();
                        AUpdate.ItemUsedQuantity -= item.ItemQuantity;
                        AUpdate.ItemNetQuantity = AUpdate.ItemQuantity - AUpdate.ItemUsedQuantity;
                        DB.Entry(AUpdate);
                        DB.SaveChanges();
                    }

                }
                DB.tblTransferItems.RemoveRange(Data1);
                DB.tblTransfers.Remove(Data);
                DB.SaveChanges();
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


        public JsonResult GetCheckinList(int ItemId, int WarehouseId = 0)
        {
            List<GetTCheckinList_Result> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.GetTCheckinList(ItemId, WarehouseId).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return new JsonResult { Data = allsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
        }

        public JsonResult GetCheckinItemData(int CheckinItemId, string Number)
        {
            GetCheckinItemData_Result3 allsearch = null;
            GetTransferItemData_Result3 Tallsearch = null;
            GetAdjustmentItemData_Result2 Aallsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                if (Number[0] == 'T')
                {
                    Tallsearch = DB.GetTransferItemData(CheckinItemId).FirstOrDefault();
                    return new JsonResult { Data = Tallsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
                }
                if (Number[0] == 'C')
                {
                    allsearch = DB.GetCheckinItemData(CheckinItemId).FirstOrDefault();
                    return new JsonResult { Data = allsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
                }
                if (Number[0] == 'A')
                {
                    Aallsearch = DB.GetAdjustmentItemData(CheckinItemId).FirstOrDefault();
                    return new JsonResult { Data = Aallsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
                }


            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return new JsonResult { Data = allsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
        }

        public ActionResult ViewTransfer(int Id)
        {
            List<TransferViewData_Result> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.TransferViewData(Id).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View(allsearch);
        }

    }
}