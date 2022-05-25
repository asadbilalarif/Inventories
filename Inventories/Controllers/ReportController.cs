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

            ViewBag.StartDate = DateTime.Now.ToString("yyyy-MM-dd"); 
            ViewBag.EndDate = DateTime.Now.ToString("yyyy-MM-dd"); 
            ViewBag.StartCreatedDate = DateTime.Now.ToString("yyyy-MM-dd"); 
            ViewBag.EndCreatedDate = DateTime.Now.ToString("yyyy-MM-dd"); 
            ViewBag.Reference = "";
            ViewBag.Contact = 0;
            ViewBag.Warehouse = 0;
            ViewBag.User = 0;
            ViewBag.Category = 0;
            ViewBag.draft = false;

            return View(CheckinList);
        }

        [HttpPost]
        public ActionResult CheckinReport(DateTime StartDate, DateTime EndDate, DateTime StartCreatedDate, DateTime EndCreatedDate, string Reference, int Contact=0, int Warehouse=0, int User=0, int Category=0, bool draft = false)
        {
            List<tblCheckin> CheckinList = DB.tblCheckins.ToList();
            ViewBag.Contacts = DB.tblContacts.ToList();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x=>x.isActive==true).ToList();
            ViewBag.Users = DB.tblUsers.ToList();
            ViewBag.Categories = DB.tblCategories.ToList();

            ViewBag.StartDate = StartDate.ToString("yyyy-MM-dd");
            ViewBag.EndDate = EndDate.ToString("yyyy-MM-dd");
            ViewBag.StartCreatedDate = StartCreatedDate.ToString("yyyy-MM-dd");
            ViewBag.EndCreatedDate = EndCreatedDate.ToString("yyyy-MM-dd");
            ViewBag.Reference = Reference;
            ViewBag.Contact = Contact;
            ViewBag.Warehouse = Warehouse;
            ViewBag.User = User;
            ViewBag.Category = Category;
            ViewBag.draft = draft;

            return View(CheckinList);
        }
    }
}