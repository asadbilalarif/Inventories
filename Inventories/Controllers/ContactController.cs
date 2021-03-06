using Inventories.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static Inventories.FilterConfig;

namespace Inventories.Controllers
{
    [Authorize]
    [AuthorizeAction1FilterAttribute]
    public class ContactController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        // GET: Contact
        public ActionResult Contacts(string Success, string Update, string Delete)
        {
            List<tblContact> ContactList = DB.tblContacts.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;

            ViewBag.Access = Session["Access"];
            List<tblAccessLevel> AccessLevel = (List<tblAccessLevel>)ViewBag.Access;
            foreach (var item in AccessLevel)
            {
                if (item.MenuId == 7)
                {
                    ViewBag.CreateAccess = item.CreateAccess;
                    ViewBag.EditAccess = item.EditAccess;
                    ViewBag.DeleteAccess = item.DeleteAccess;
                }
            }

            return View(ContactList);
        }



        public ActionResult CreateContact(int? id)
        {
            tblContact Contact = null;
            if (id != null && id != 0)
            {
                Contact = DB.tblContacts.Where(x => x.ContactId == id).FirstOrDefault();
                return View(Contact);
            }
            else
            {
                return View(Contact);
            }
        }


        [HttpPost]
        public ActionResult CreateContact(tblContact Contact)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblContact Data = new tblContact();
            try
            {
                if (Contact.ContactId == 0)
                {
                    if (DB.tblContacts.Select(r => r).Where(x => x.Email == Contact.Email).FirstOrDefault() == null)
                    {


                        Data = Contact;
                        Data.CreatedDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.CreatedBy = UserId;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = UserId;
                        Data.isActive = true;
                        DB.tblContacts.Add(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Contacts", new { Success = "Contact has been add successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Contact Already Exsist!!!";
                    }
                }
                else
                {
                    var check = DB.tblContacts.Select(r => r).Where(x =>x.Email == Contact.Email).FirstOrDefault();
                    if (check == null || check.ContactId == Contact.ContactId)
                    {
                        Data = DB.tblContacts.Select(r => r).Where(x => x.ContactId == Contact.ContactId).FirstOrDefault();
                        Data.Name = Contact.Name;
                        Data.Phone = Contact.Phone;
                        Data.ContactType = Contact.ContactType;
                        Data.Email = Contact.Email;
                        Data.Details = Contact.Details;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = UserId;
                        DB.Entry(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Contacts", new { Update = "Contact has been Update successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Contact Already Exsist!!!";
                    }

                }


            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return RedirectToAction("Contacts");
        }


        [HttpPost]
        public ActionResult DeleteContact(int ContactId)
        {
            tblContact Data = new tblContact();
            try
            {
                Data = DB.tblContacts.Select(r => r).Where(x => x.ContactId == ContactId).FirstOrDefault();
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