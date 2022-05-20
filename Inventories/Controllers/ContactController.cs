using Inventories.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
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

            tblContact Data = new tblContact();
            try
            {
                if (Contact.ContactId == 0)
                {
                    if (DB.tblContacts.Select(r => r).Where(x => x.Email == Contact.Email).FirstOrDefault() == null)
                    {


                        Data = Contact;
                        Data.CreatedDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.CreatedBy = 1;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = 1;
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
                        Data.Email = Contact.Email;
                        Data.Details = Contact.Details;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = 1;
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