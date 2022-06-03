using Inventories.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static Inventories.FilterConfig;

namespace Inventories.Controllers
{
    [Authorize]
    [AuthorizeAction1FilterAttribute]
    public class SettingController : Controller
    {
        // GET: Setting
        InventoriesEntities DB = new InventoriesEntities();
        public ActionResult EmailSetting(int? isSuccess)
        {
            var Data = DB.tblEmailSettings.FirstOrDefault();
            if (isSuccess == 1)
            {
                ViewBag.Error = "Record Successfully Updated!!!";
            }
            return View(Data);
        }

        [HttpPost]
        public ActionResult CreateEmailSetting(tblEmailSetting Setting)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblEmailSetting Data = new tblEmailSetting();
            try
            {
                if (Setting.isActive == null)
                {
                    Setting.isActive = false;
                }
                //Foreign = DB.tblRoles.Where(x => x.RoleId == Setting.RoleId).FirstOrDefault();
                //Data.tblRole = Foreign;
                Data = DB.tblEmailSettings.Select(r => r).Where(x => x.EmailSettingId == Setting.EmailSettingId).FirstOrDefault();
                Data.Email = Setting.Email;
                Data.Password = Setting.Password;
                Data.SMTP = Setting.SMTP;
                Data.Port = Setting.Port;
                Data.isActive = Setting.isActive;
                Data.EditBy = UserId;
                Data.EditDate = DateTime.Now;
                DB.Entry(Data);
                DB.SaveChanges();

            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return RedirectToAction("EmailSetting", new { isSuccess = 1 });
        }


        public ActionResult Setting(int? isSuccess)
        {
            var Data = DB.tblSettings.FirstOrDefault();
            if (isSuccess == 1)
            {
                ViewBag.Error = "Record Successfully Updated!!!";
            }
            return View(Data);
        }

        [HttpPost]
        public ActionResult CreateSetting(tblSetting Setting, HttpPostedFileBase CLogo)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblSetting Data = new tblSetting();
            try
            {
                Data = DB.tblSettings.Select(r => r).Where(x => x.SettingId == Setting.SettingId).FirstOrDefault();
                MemoryStream target = new MemoryStream();
                if (CLogo != null)
                {
                    CLogo.InputStream.CopyTo(target);
                    Data.Logo = target.ToArray();
                }
                Data.Name = Setting.Name;
                Data.Color = Setting.Color;
                Data.EditBy = UserId;
                Data.EditDate = DateTime.Now;
                DB.Entry(Data);
                DB.SaveChanges();

            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return RedirectToAction("Setting", new { isSuccess = 1 });
        }
    }
}