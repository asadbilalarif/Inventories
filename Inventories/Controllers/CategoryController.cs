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
    public class CategoryController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        // GET: Category
        public ActionResult Categories(string Success, string Update, string Delete)
        {
            List<tblCategory> CategoryList = DB.tblCategories.ToList();
            ViewBag.Success = Success;
            ViewBag.Update = Update;
            ViewBag.Delete = Delete;
            return View(CategoryList);
        }

        public ActionResult CreateCategory(int? id)
        {
            tblCategory Category = null;
            if (id != null && id != 0)
            {
                Category = DB.tblCategories.Where(x => x.CategoryId == id).FirstOrDefault();
                return View(Category);
            }
            else
            {
                return View(Category);
            }
        }


        [HttpPost]
        public ActionResult CreateCategory(tblCategory Category)
        {
            HttpCookie cookieObj = Request.Cookies["User"];
            int UserId = Int32.Parse(cookieObj["UserId"]);
            tblCategory Data = new tblCategory();
            try
            {
                if (Category.CategoryId == 0)
                {
                    if (DB.tblCategories.Select(r => r).Where(x => x.Name == Category.Name).FirstOrDefault() == null)
                    {


                        Data = Category;
                        Data.CreatedDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.CreatedBy = UserId;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = UserId;
                        Data.isActive = true;
                        DB.tblCategories.Add(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Categories", new { Success = "Category has been add successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Category Already Exsist!!!";
                    }
                }
                else
                {
                    var check = DB.tblCategories.Select(r => r).Where(x => x.Name == Category.Name).FirstOrDefault();
                    if (check == null || check.CategoryId == Category.CategoryId)
                    {
                        Data = DB.tblCategories.Select(r => r).Where(x => x.CategoryId == Category.CategoryId).FirstOrDefault();
                        Data.Name = Category.Name;
                        Data.Code = Category.Code;
                        Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        Data.EditBy = UserId;
                        DB.Entry(Data);
                        DB.SaveChanges();
                        return RedirectToAction("Categories", new { Update = "Category has been Update successfully." });
                    }
                    else
                    {
                        ViewBag.Error = "Category Already Exsist!!!";
                    }

                }


            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return RedirectToAction("Categories");
        }

        [HttpPost]
        public ActionResult DeleteCategory(int CategoryId)
        {
            tblCategory Data = new tblCategory();
            try
            {
                Data = DB.tblCategories.Select(r => r).Where(x => x.CategoryId == CategoryId).FirstOrDefault();
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