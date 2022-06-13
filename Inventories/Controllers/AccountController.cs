using Inventories.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Inventories.Controllers
{
    public class AccountController : Controller
    {
        InventoriesEntities DB = new InventoriesEntities();
        // GET: Account
        public ActionResult Login()
        {
            FormsAuthentication.SignOut();
            
            return View();
        }
        [HttpPost]
        public ActionResult Login(string Email, string Password)
        {
            string pass = null;
           
            try
            {
                if (Password != null)
                {
                    byte[] EncDataBtye = new byte[Password.Length];
                    EncDataBtye = System.Text.Encoding.UTF8.GetBytes(Password);
                    pass = Convert.ToBase64String(EncDataBtye);
                }

                if (DB.tblUsers.Select(r => r).Where(x => x.Email == Email && x.Password == pass && x.isActive != false).FirstOrDefault() != null)
                {
                    var User = DB.tblUsers.Select(r => r).Where(x => x.Email == Email).FirstOrDefault();

                    HttpCookie cookie = new HttpCookie("User");

                    cookie["Email"] = User.Email;
                    cookie["UserId"] = User.UserId.ToString();
                    cookie["Role"] = User.tblRole.Role;


                    HttpCookie Settingcookie = new HttpCookie("Setting");
                    tblSetting Setting = DB.tblSettings.FirstOrDefault();
                    Settingcookie["Name"] = Setting.Name;
                    Settingcookie["Color"] = Setting.Color;
                    Settingcookie["HoverColor"] = Setting.HoverColor;
                    Response.Cookies.Add(Settingcookie);

                    //Session["User"] = DB.tblUsers.Select(r => r).Where(x => x.Email == Email).FirstOrDefault();
                    Session["access"] = DB.tblAccessLevels.Select(r => r).Where(x => x.RoleId == User.RoleId && x.isActive == true).ToList();
                    // This cookie will remain  for one month.
                    cookie.Expires = DateTime.Now.AddMonths(1);

                    // Add it to the current web response.
                    Response.Cookies.Add(cookie);
                    

                    FormsAuthentication.SetAuthCookie(Email, false);

                    return RedirectToAction("Index", "Home");
                }
                else
                {
                    var UserCheck = DB.tblUsers.Select(r => r).Where(x => x.Email == Email && x.Password == pass).FirstOrDefault();
                    if (UserCheck != null && UserCheck.isActive == false)
                    {
                        ViewBag.Error = "User is in-active";
                    }
                    else
                    {
                        ViewBag.Error = "Invalid Email or Password";
                    }

                    return View();
                }
            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return RedirectToAction("Index", "Home");
        }


        public ActionResult ForgetPassword()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ForgetPassword(string Email)
        {
            try
            {
                if (DB.tblUsers.Where(x => x.Email == Email).FirstOrDefault() != null)
                {

                    tblEmailSetting setting = DB.tblEmailSettings.Find(1);
                    string SenderEmail = setting.Email;//System.Configuration.ConfigurationManager.AppSettings["SenderEmail"].ToString();
                    string SenderPassword = setting.Password;//System.Configuration.ConfigurationManager.AppSettings["SenderPassword"].ToString();
                    SmtpClient Client = new SmtpClient(setting.SMTP, Convert.ToInt32(setting.Port));
                    Client.EnableSsl = Convert.ToBoolean(setting.isActive);

                    //string SenderEmail = System.Configuration.ConfigurationManager.AppSettings["SenderEmail"].ToString();
                    //string SenderPassword = System.Configuration.ConfigurationManager.AppSettings["SenderPassword"].ToString();
                    //SmtpClient Client = new SmtpClient("smtp.gmail.com", 587);
                    //Client.EnableSsl = true;
                    Client.Timeout = 100000;
                    Client.DeliveryMethod = SmtpDeliveryMethod.Network;
                    Client.UseDefaultCredentials = false;
                    Client.Credentials = new System.Net.NetworkCredential(SenderEmail, SenderPassword);

                    string link = Request.Url.ToString();
                    link = link.Replace("ForgetPassword", "ChangeForgetPassword");

                    byte[] b = System.Text.ASCIIEncoding.ASCII.GetBytes(Email);
                    string encrypted = Convert.ToBase64String(b);

                    byte[] t = System.Text.ASCIIEncoding.ASCII.GetBytes(DateTime.Now.ToString());
                    string encryptedTime = Convert.ToBase64String(t);


                    string body1 = "";
                    body1 += "Welcome to Invertories!";
                    body1 += "<br />To Change your password, please click on the button below: ";
                    body1 += "<br /> <button style='padding: 10px 28px 11px 28px;color: #fff;background:rgba(40, 58, 90, 0.9);'><a style='color:white !important' href = '" + link + "?Email=" + encrypted + "&&Expire="+ encryptedTime + "'>Change Account Password</a></button>";
                    body1 += "<br /><br />Yours,<br />The WSA Team";

                    string body = "";
                    body += "<body  style='background-color:white !important'>";
                    body += " <div>";
                    //body += "<h3>Hello " + sa.ReceiveName + ",</h3>";
                    body += " <table style='background-color: #f2f3f8; max-width:670px;' width='100%' border='0'  cellpadding='0' cellspacing='0'>";
                    body += " <tbody> <tr style='background-color:rgba(40, 58, 90, 0.9);'><td style='padding: 0 35px; background-color:rgba(40, 58, 90, 0.9);'><a><h1 style ='color:white' > World Service Authority </h1>   </a></td> </tr>";
                    body += "<tr style='color:#455056; font-size:15px;line-height:35px;text-align: center;'><td style='padding:6px;text-align: center;'></td></tr><tr style='color:#455056; font-size:15px;line-height:35px;text-align: center;'><td style='padding:6px;text-align: center;'>" + body1 + "</td></tr>";
                    body += "  </tbody></table>";
                    body += "</body>";


                    MailMessage mailMessage = new MailMessage(SenderEmail, Email, "Forget Password Email", body);
                    mailMessage.IsBodyHtml = true;
                    mailMessage.BodyEncoding = System.Text.UTF8Encoding.UTF8;

                    Client.Send(mailMessage);

                    //mailMessage = new MailMessage(SenderEmail, Email, "Thank You Email", "Thank You for Contacting Us!!!");
                    //mailMessage.IsBodyHtml = true;
                    //mailMessage.BodyEncoding = System.Text.UTF8Encoding.UTF8;

                    //Client.Send(mailMessage);

                    ViewBag.Success = "Email has been successfully sent";
                    return View();
                }
                else
                {
                    ViewBag.Error = "User not register";
                    return View();
                }

            }
            catch (Exception ex)
            {
                throw ex;
                // View();
            }
        }


        public ActionResult ChangeForgetPassword(string Email)
        {
            try
            {
                byte[] b = Convert.FromBase64String(Email);
                string decrypted = System.Text.ASCIIEncoding.ASCII.GetString(b);

                ViewBag.Email = decrypted;
            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }
            return View();
        }


        [HttpPost]
        public ActionResult ChangeForgetPassword(string NewPassword, string ConfirmPassword, string Email)
        {
            string pass = null;
            try
            {


                byte[] EncDataBtye = null;
                tblUser Data = new tblUser();
                Data = DB.tblUsers.Select(r => r).Where(x => x.Email == Email).FirstOrDefault();
                if (Data != null)
                {

                    if (NewPassword == ConfirmPassword)
                    {
                        EncDataBtye = new byte[NewPassword.Length];
                        EncDataBtye = System.Text.Encoding.UTF8.GetBytes(NewPassword);
                        pass = Convert.ToBase64String(EncDataBtye);
                    }
                    else
                    {
                        ViewBag.PError = "New Password and Confirm Password not Matched!!!";
                        return View();
                    }

                    Data.Password = pass;
                    Data.EditDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    DB.Entry(Data);
                    DB.SaveChanges();
                    return RedirectToAction("Login", "Account");
                }
                else
                {
                    ViewBag.Error = "Old password is not Correct!!!";
                    return View();
                }


            }
            catch (Exception ex)
            {

                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View();
        }

        public ActionResult ChangeLanguage(string lang)
        {
            Session["lang"] = lang;
            if(lang=="es")
            {
                Session["CurrentCulture"] = 2.ToString();
            }
            else
            {
                Session["CurrentCulture"] = 0.ToString();
            }
            return RedirectToAction("Index", "Home", new { language = lang });
        }

    }
}