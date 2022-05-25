using Inventories.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
    public class ReportController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        // GET: Report
        public ActionResult CheckinReport()
        {
            List<tblCheckin> CheckinList = DB.tblCheckins.ToList();
            ViewBag.Contacts = DB.tblContacts.ToList();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x=>x.isActive==true).ToList();
            ViewBag.Users = DB.tblUsers.ToList();
            ViewBag.Categories = DB.tblCategories.ToList();
            return View(CheckinList);
        }
    }
}