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
        public ActionResult CreateCheckout(tblCheckout[] HeadData, List<PCheckoutItem> TailData)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblCheckout Data = new tblCheckout();
            tblCheckoutItem Data2 = new tblCheckoutItem();
            tblCheckinItem Update = new tblCheckinItem();
            tblTransferItem TUpdate = new tblTransferItem();
            tblAdjustmentItem AUpdate = new tblAdjustmentItem();
            tblCheckoutItem Delete = new tblCheckoutItem();
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
                    TailData = new List<PCheckoutItem>();
                }

                bool First = false;
                //Loop and insert records.


                foreach (PCheckoutItem Item in TailData)
                {
                    if (First)
                    {
                        Update = new tblCheckinItem();
                        TUpdate = new tblTransferItem();
                        AUpdate = new tblAdjustmentItem();
                        Data2 = new tblCheckoutItem();
                        Data2.CheckoutId = Data.CheckoutId;
                        Data2.CreatedBy = UserId;
                        Data2.CreatedDate = DateTime.Now;
                        Data2.ItemId = Item.ItemId;
                        Data2.ItemWeight = Item.ItemWeight;
                        Data2.ItemQuantity = Item.ItemQuantity;
                        Data2.ItemUnit = Item.ItemUnit;
                        Data2.CheckinItemId = Item.CheckinItemId;
                        Data2.VNumber = Item.Number;
                        if(Item.Number[0]=='C')
                        {
                            Update = DB.tblCheckinItems.Where(x => x.CheckinItemId == Item.CheckinItemId).FirstOrDefault();
                            Update.ItemUsedQuantity = Update.ItemUsedQuantity + Item.ItemQuantity;
                            Update.ItemNetQuantity = Update.ItemQuantity - Update.ItemUsedQuantity;
                            DB.Entry(Update);
                            DB.SaveChanges();
                        }
                        if(Item.Number[0]=='T')
                        {
                            TUpdate = DB.tblTransferItems.Where(x => x.TransferItemId == Item.CheckinItemId).FirstOrDefault();
                            TUpdate.ItemUsedQuantity = TUpdate.ItemUsedQuantity + Item.ItemQuantity;
                            TUpdate.ItemNetQuantity = TUpdate.ItemQuantity - TUpdate.ItemUsedQuantity;
                            DB.Entry(TUpdate);
                            DB.SaveChanges();
                        }
                        if(Item.Number[0]=='A')
                        {
                            AUpdate = DB.tblAdjustmentItems.Where(x => x.AdjustmentItemId == Item.CheckinItemId).FirstOrDefault();
                            AUpdate.ItemUsedQuantity = AUpdate.ItemUsedQuantity + Item.ItemQuantity;
                            AUpdate.ItemNetQuantity = AUpdate.ItemQuantity - AUpdate.ItemUsedQuantity;
                            DB.Entry(AUpdate);
                            DB.SaveChanges();
                        }
                        
                        DB.tblCheckoutItems.Add(Data2);
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


                foreach (var item in TailData)
                {
                    if(item.Deleted==true)
                    {
                        Update = new tblCheckinItem();
                        TUpdate = new tblTransferItem();
                        AUpdate = new tblAdjustmentItem();
                        Delete = new tblCheckoutItem();
                        if (item.Number[0] == 'C')
                        {
                            Update = DB.tblCheckinItems.Where(x => x.CheckinItemId == item.CheckinItemId).FirstOrDefault();
                            Update.ItemUsedQuantity = Update.ItemUsedQuantity - item.ItemQuantity;
                            Update.ItemNetQuantity = Update.ItemQuantity - Update.ItemUsedQuantity;
                            DB.Entry(Update);
                            DB.SaveChanges();
                        }
                        if (item.Number[0] == 'T')
                        {
                            TUpdate = DB.tblTransferItems.Where(x => x.TransferItemId == item.CheckinItemId).FirstOrDefault();
                            TUpdate.ItemUsedQuantity = TUpdate.ItemUsedQuantity - item.ItemQuantity;
                            TUpdate.ItemNetQuantity = TUpdate.ItemQuantity - TUpdate.ItemUsedQuantity;
                            DB.Entry(TUpdate);
                            DB.SaveChanges();
                        }
                        if (item.Number[0] == 'A')
                        {
                            AUpdate = DB.tblAdjustmentItems.Where(x => x.AdjustmentItemId == item.CheckinItemId).FirstOrDefault();
                            AUpdate.ItemUsedQuantity = AUpdate.ItemUsedQuantity - item.ItemQuantity;
                            AUpdate.ItemNetQuantity = AUpdate.ItemQuantity - AUpdate.ItemUsedQuantity;
                            DB.Entry(AUpdate);
                            DB.SaveChanges();
                        }
                        DB.Entry(Update);
                        DB.SaveChanges();
                        Delete=DB.tblCheckoutItems.Where(x => x.CheckinItemId == item.CheckinItemId).FirstOrDefault();
                        DB.tblCheckoutItems.Remove(Delete);
                        DB.SaveChanges();
                    }
                }

                //List<tblCheckoutItem> TData;
                //int CheckoutId = Data.CheckoutId;
                //TData = DB.tblCheckoutItems.Select(r => r).Where(x => x.CheckoutId == CheckoutId).ToList();

                //DB.tblCheckoutItems.RemoveRange(TData);
                //DB.SaveChanges();

                if (TailData == null)
                {
                    TailData = new List<PCheckoutItem>();
                }

                bool First = false;
                //Loop and insert records.
                foreach (PCheckoutItem Item in TailData)
                {
                    if (First)
                    {
                        if(Item.Deleted != true)
                        {

                            var Check = DB.tblCheckoutItems.Where(x => x.CheckinItemId == Item.CheckinItemId).Select(s => s).FirstOrDefault();
                            if (Check == null)
                            {
                                Update = new tblCheckinItem();
                                TUpdate = new tblTransferItem();
                                AUpdate = new tblAdjustmentItem();
                                Data2 = new tblCheckoutItem();
                                Data2.CheckoutId = Data.CheckoutId;
                                Data2.CreatedBy = UserId;
                                Data2.CreatedDate = DateTime.Now;
                                Data2.ItemId = Item.ItemId;
                                Data2.ItemWeight = Item.ItemWeight;
                                Data2.ItemQuantity = Item.ItemQuantity;
                                Data2.ItemUnit = Item.ItemUnit;
                                Data2.CheckinItemId = Item.CheckinItemId;
                                if (Item.Number[0] == 'C')
                                {
                                    Update = DB.tblCheckinItems.Where(x => x.CheckinItemId == Item.CheckinItemId).FirstOrDefault();
                                    Update.ItemUsedQuantity = Update.ItemUsedQuantity + Item.ItemQuantity;
                                    Update.ItemNetQuantity = Update.ItemQuantity - Update.ItemUsedQuantity;
                                    DB.Entry(Update);
                                    DB.SaveChanges();
                                }
                                if (Item.Number[0] == 'T')
                                {
                                    TUpdate = DB.tblTransferItems.Where(x => x.TransferItemId == Item.CheckinItemId).FirstOrDefault();
                                    TUpdate.ItemUsedQuantity = TUpdate.ItemUsedQuantity + Item.ItemQuantity;
                                    TUpdate.ItemNetQuantity = TUpdate.ItemQuantity - TUpdate.ItemUsedQuantity;
                                    DB.Entry(TUpdate);
                                    DB.SaveChanges();
                                }
                                if (Item.Number[0] == 'A')
                                {
                                    AUpdate = DB.tblAdjustmentItems.Where(x => x.AdjustmentItemId == Item.CheckinItemId).FirstOrDefault();
                                    AUpdate.ItemUsedQuantity = AUpdate.ItemUsedQuantity + Item.ItemQuantity;
                                    AUpdate.ItemNetQuantity = AUpdate.ItemQuantity - AUpdate.ItemUsedQuantity;
                                    DB.Entry(AUpdate);
                                    DB.SaveChanges();
                                }
                                DB.Entry(Update);
                                DB.SaveChanges();
                                DB.tblCheckoutItems.Add(Data2);
                            }
                        }
                        
                        
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
            tblCheckinItem UpdateCheckinQty = new tblCheckinItem();
            tblTransferItem TUpdateCheckinQty = new tblTransferItem();
            tblAdjustmentItem AUpdateCheckinQty = new tblAdjustmentItem();
            List<tblCheckoutItem> Data1 = new List<tblCheckoutItem>();
            Data = DB.tblCheckouts.Where(x => x.CheckoutId == Id).FirstOrDefault();
            Data1 = DB.tblCheckoutItems.Where(x => x.CheckoutId == Id).ToList();
            foreach (tblCheckoutItem item in Data1)
            {
                UpdateCheckinQty = new tblCheckinItem();
                TUpdateCheckinQty = new tblTransferItem();
                AUpdateCheckinQty = new tblAdjustmentItem();
                if(item.VNumber[0]=='C')
                {
                    UpdateCheckinQty = DB.tblCheckinItems.Where(x => x.CheckinItemId == item.CheckinItemId).FirstOrDefault();
                    UpdateCheckinQty.ItemUsedQuantity -= item.ItemQuantity;
                    UpdateCheckinQty.ItemNetQuantity = UpdateCheckinQty.ItemQuantity - UpdateCheckinQty.ItemUsedQuantity;
                    DB.Entry(UpdateCheckinQty);
                    DB.SaveChanges();
                }
                if(item.VNumber[0]=='T')
                {
                    TUpdateCheckinQty = DB.tblTransferItems.Where(x => x.TransferItemId == item.CheckinItemId).FirstOrDefault();
                    TUpdateCheckinQty.ItemUsedQuantity -= item.ItemQuantity;
                    TUpdateCheckinQty.ItemNetQuantity = TUpdateCheckinQty.ItemQuantity - TUpdateCheckinQty.ItemUsedQuantity;
                    DB.Entry(TUpdateCheckinQty);
                    DB.SaveChanges();
                }
                if(item.VNumber[0]=='A')
                {
                    AUpdateCheckinQty = DB.tblAdjustmentItems.Where(x => x.AdjustmentItemId == item.CheckinItemId).FirstOrDefault();
                    AUpdateCheckinQty.ItemUsedQuantity -= item.ItemQuantity;
                    AUpdateCheckinQty.ItemNetQuantity = AUpdateCheckinQty.ItemQuantity - AUpdateCheckinQty.ItemUsedQuantity;
                    DB.Entry(AUpdateCheckinQty);
                    DB.SaveChanges();
                }
                
            }
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

        public JsonResult GetCheckinList(int ItemId,int WarehouseId=0)
        {
            List<GetCheckinList_Result1> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.GetCheckinList(ItemId, WarehouseId).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return new JsonResult { Data = allsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
        }

        public JsonResult GetCheckinItemData(int CheckinItemId,string Number)
        {
            GetCheckinItemData_Result3 allsearch = null;
            GetTransferItemData_Result3 Tallsearch = null;
            GetAdjustmentItemData_Result2 Aallsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                if(Number[0]=='T')
                {
                    Tallsearch = DB.GetTransferItemData(CheckinItemId).FirstOrDefault();
                    return new JsonResult { Data = Tallsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
                }
                if(Number[0] == 'C')
                {
                    allsearch = DB.GetCheckinItemData(CheckinItemId).FirstOrDefault();
                    return new JsonResult { Data = allsearch, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
                }
                if(Number[0] == 'A')
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
    }
}