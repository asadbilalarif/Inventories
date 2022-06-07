using Inventories.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static Inventories.FilterConfig;

namespace Inventories.Controllers
{
    [Authorize]
    [AuthorizeAction1FilterAttribute]
    public class HomeController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        public ActionResult Index()
        {
            ViewBag.Alert= DB.tblAlertQties.Where(x => x.Notify == true).ToList();
            ViewBag.AlertCount=DB.tblAlertQties.Where(x => x.Notify == true).Count();
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult RetrieveImage(int id)
        {
            byte[] cover = GetImageFromDataBase(id);
            if (cover != null)
            {
                return File(cover, "image/jpg");
            }
            else
            {
                return null;
            }
        }

        public byte[] GetImageFromDataBase(int Id)
        {
            var q = DB.tblSettings.Where(x => x.SettingId == Id).Select(s => s.Logo).FirstOrDefault();
            byte[] cover = q;
            return cover;
        }

    }
}