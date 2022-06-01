using Inventories.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
    [Authorize]
    public class UnitController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        // GET: Unit
        public ActionResult Units(string Success, string Update, string Delete)
        {
            List<tblUnit> UnitList = DB.tblUnits.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;
            return View(UnitList);
        }

        public ActionResult CreateUnit(int? id)
        {
                tblUnit Unit = null;
            try
            {
                if (id != null && id != 0)
                {
                    Unit = DB.tblUnits.Where(x => x.UnitId == id).FirstOrDefault();
                    return View(Unit);
                }
                else
                {
                    return View(Unit);
                }
            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }
            return View(Unit);
        }


        [HttpPost]
        public ActionResult CreateUnit(tblUnit Unit)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblUnit Data = new tblUnit();
            try
            {
                if (Unit.UnitId == 0)
                {
                    if (DB.tblUnits.Select(r => r).Where(x => x.Name == Unit.Name).FirstOrDefault() == null)
                    {


                        Data = Unit;
                        Data.CreatedDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.CreatedBy = UserId;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = UserId;
                        Data.isActive = true;
                        DB.tblUnits.Add(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Units", new { Success = "Unit has been add successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Unit Already Exsist!!!";
                    }
                }
                else
                {
                    var check = DB.tblUnits.Select(r => r).Where(x => x.Name == Unit.Name).FirstOrDefault();
                    if (check == null || check.UnitId == Unit.UnitId)
                    {
                        Data = DB.tblUnits.Select(r => r).Where(x => x.UnitId == Unit.UnitId).FirstOrDefault();
                        Data.Name = Unit.Name;
                        Data.Code = Unit.Code;
                        Data.BaseUnit = Unit.BaseUnit;
                        Data.Operator = Unit.Operator;
                        Data.OperationValue = Unit.OperationValue;
                        Data.Formula = Unit.Formula;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = UserId;
                        DB.Entry(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Units", new { Update = "Unit has been Update successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Unit Already Exsist!!!";
                    }

                }


            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return RedirectToAction("Units");
        }


        [HttpPost]
        public ActionResult DeleteUnit(int UnitId)
        {
            tblUnit Data = new tblUnit();
            try
            {
                Data = DB.tblUnits.Select(r => r).Where(x => x.UnitId == UnitId).FirstOrDefault();
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