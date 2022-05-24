using Inventories.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
    public class ItemController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        // GET: Item
        public ActionResult Items(string Success, string Update, string Delete)
        {
            List<tblItem> ItemList = DB.tblItems.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;
            return View(ItemList);
        }

        public ActionResult CreateItem(int? id)
        {
            tblItem Item = null;
            ViewBag.Caterories = DB.tblCategories.ToList();
            if (id != null && id != 0)
            {
                Item = DB.tblItems.Where(x => x.ItemId == id).FirstOrDefault();
                return View(Item);
            }
            else
            {
                return View(Item);
            }
        }


        [HttpPost]
        public ActionResult CreateItem(tblItem Item, HttpPostedFileBase CLogo)
        {

            tblItem Data = new tblItem();
            try
            {
                if (Item.ItemId == 0)
                {
                    if (DB.tblItems.Select(r => r).Where(x => x.Name == Item.Name).FirstOrDefault() == null)
                    {
                        

                        Data = Item;
                        Data.CreatedDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.CreatedBy = 1;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = 1;
                        Data.isActive = true;
                        DB.tblItems.Add(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Items", new { Success = "Item has been add successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Item Already Exsist!!!";
                    }
                }
                else
                {
                    var check = DB.tblItems.Select(r => r).Where(x => x.Name == Item.Name).FirstOrDefault();
                    if (check == null || check.ItemId == Item.ItemId)
                    {
                        Data = DB.tblItems.Select(r => r).Where(x => x.ItemId == Item.ItemId).FirstOrDefault();
                       
                        Data.Name = Item.Name;
                        Data.Code = Item.Code;
                        Data.CategoryId = Item.CategoryId;
                        Data.Unit = Item.Unit;
                        Data.BarcodeSymbology = Item.BarcodeSymbology;
                        Data.RackLocation = Item.RackLocation;
                        Data.SKU = Item.SKU;
                        Data.Details = Item.Details;
                        Data.TrackQuantity = Item.TrackQuantity;
                        Data.Alertonlowstock = Item.Alertonlowstock;
                        Data.isActive = Item.isActive;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = 1;
                        DB.Entry(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Items", new { Update = "Item has been Update successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Item Already Exsist!!!";
                    }

                }


            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return RedirectToAction("Items");
        }

        [HttpPost]
        public ActionResult DeleteItem(int ItemId)
        {
            tblItem Data = new tblItem();
            try
            {
                Data = DB.tblItems.Select(r => r).Where(x => x.ItemId == ItemId).FirstOrDefault();
                DB.Entry(Data).State = EntityState.Deleted;
                DB.SaveChanges();
                return Json(1);
            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return Json(0);
        }
    }
}