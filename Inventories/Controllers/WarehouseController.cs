using Inventories.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
    public class WarehouseController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        // GET: Warehouse
        public ActionResult Warehouses(string Success, string Update, string Delete)
        {
            List<tblWarehouse> WarehouseList = DB.tblWarehouses.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;
            return View(WarehouseList);
        }

        public ActionResult CreateWarehouse(int? id)
        {
            tblWarehouse Warehouse = null;
            if (id != null && id != 0)
            {
                Warehouse = DB.tblWarehouses.Where(x => x.WarehouseId == id).FirstOrDefault();
                return View(Warehouse);
            }
            else
            {
                return View(Warehouse);
            }
        }


        [HttpPost]
        public ActionResult CreateWarehouse(tblWarehouse Warehouse,HttpPostedFileBase CLogo)
        {

            tblWarehouse Data = new tblWarehouse();
            try
            {
                string folder = Server.MapPath(string.Format("~/{0}/", "Uploading"));
                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }
                if (Warehouse.WarehouseId == 0)
                {
                    if (DB.tblWarehouses.Select(r => r).Where(x => x.Name == Warehouse.Name).FirstOrDefault() == null)
                    {
                       
                        string path = null;

                        if (CLogo != null)
                        {
                            path = Path.Combine(Server.MapPath("~/Uploading"), Path.GetFileName(CLogo.FileName));
                            CLogo.SaveAs(path);
                            path = Path.Combine("\\Uploading", Path.GetFileName(CLogo.FileName));
                            Data.Logo = path;
                        }

                        Data = Warehouse;
                        Data.CreatedDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.CreatedBy = 1;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = 1;
                        Data.isActive = true;
                        DB.tblWarehouses.Add(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Warehouses", new { Success = "Warehouse has been add successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Warehouse Already Exsist!!!";
                    }
                }
                else
                {
                    var check = DB.tblWarehouses.Select(r => r).Where(x => x.Name == Warehouse.Name).FirstOrDefault();
                    if (check == null || check.WarehouseId == Warehouse.WarehouseId)
                    {
                        Data = DB.tblWarehouses.Select(r => r).Where(x => x.WarehouseId == Warehouse.WarehouseId).FirstOrDefault();
                        string path = null;
                        if (CLogo != null)
                        {
                            path = Path.Combine(Server.MapPath("~/Uploading"), Path.GetFileName(CLogo.FileName));

                            CLogo.SaveAs(path);
                            path = Path.Combine("\\Uploading", Path.GetFileName(CLogo.FileName));

                            Data.Logo = path;
                        }
                        Data.Name = Warehouse.Name;
                        Data.Code = Warehouse.Code;
                        Data.Phone = Warehouse.Phone;
                        Data.Email = Warehouse.Email;
                        Data.Address = Warehouse.Address;
                        Data.isActive = Warehouse.isActive;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = 1;
                        DB.Entry(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Warehouses", new { Update = "Warehouse has been Update successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Warehouse Already Exsist!!!";
                    }

                }


            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return RedirectToAction("Warehouses");
        }


        [HttpPost]
        public ActionResult DeleteWarehouse(int WarehouseId)
        {
            tblWarehouse Data = new tblWarehouse();
            try
            {
                Data = DB.tblWarehouses.Select(r => r).Where(x => x.WarehouseId == WarehouseId).FirstOrDefault();
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