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
            List<CheckinReportData_Result2> CheckinList = new List<CheckinReportData_Result2>();
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

            string Query = "";
            Query = "where 1=1 ";

            CheckinList = DB.CheckinReportData(Query).ToList();

            return View(CheckinList);
        }

        [HttpPost]
        public ActionResult CheckinReport(DateTime StartDate, DateTime EndDate, DateTime StartCreatedDate, DateTime EndCreatedDate, string Reference, int Contact=0, int Warehouse=0, int User=0, int Category=0, bool draft = false)
        {
            List<CheckinReportData_Result2> CheckinList = new List<CheckinReportData_Result2>();
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

            string References = "";
            string Contacts = "";
            string Warehouses = "";
            string Users = "";
            string Categories = "";


            string Query = "";
            if(Reference!="")
            {
                References = " and CI.Reference ='" + Reference + "' ";
            }
            if(Contact!=0)
            {
                Contacts = " and CI.Contact =" + Contact + " ";
            }
            if(Warehouse!=0)
            {
                Warehouses= " and CI.Warehouse =" + Warehouse + " ";
            }
            if(User != 0)
            {
                Users= " and CI.CreatedBy =" + User + " ";
            }
            if(User != 0)
            {
                Users= " and CI.CreatedBy =" + User + " ";
            }
            if(Category != 0)
            {
                Categories = " and I.CategoryId =" + Category + " ";
            }
            Query = "where 1=1 and Cast(CI.CheckinDate as date)>=cast('" + StartDate.ToString("MM/dd/yyyy") + "' as date ) and Cast(CI.CheckinDate as date)<=cast('" + EndDate.ToString("MM/dd/yyyy") + "' as date )" +
                " and  Cast(CI.CreatedDate as date)>=cast('" + StartCreatedDate.ToString("MM/dd/yyyy") + "' as date ) and Cast(CI.CreatedDate as date)<=cast('" + EndCreatedDate.ToString("MM/dd/yyyy") + "' as date ) " + References + " " +
                " " + Contacts + " " + Warehouses + " " + Users + " " + Categories + " and CI.draft ='" + draft + "'";

            CheckinList = DB.CheckinReportData(Query).ToList();

            return View(CheckinList);
        }


        public ActionResult CheckoutReport()
        {
            List<CheckoutReportData_Result> CheckoutList = new List<CheckoutReportData_Result>();
            ViewBag.Contacts = DB.tblContacts.ToList();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
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

            string Query = "";
            Query = "where 1=1 ";

            CheckoutList = DB.CheckoutReportData(Query).ToList();

            return View(CheckoutList);
        }

        [HttpPost]
        public ActionResult CheckoutReport(DateTime StartDate, DateTime EndDate, DateTime StartCreatedDate, DateTime EndCreatedDate, string Reference, int Contact = 0, int Warehouse = 0, int User = 0, int Category = 0, bool draft = false)
        {
            List<CheckoutReportData_Result> CheckoutList = new List<CheckoutReportData_Result>();
            ViewBag.Contacts = DB.tblContacts.ToList();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
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

            string References = "";
            string Contacts = "";
            string Warehouses = "";
            string Users = "";
            string Categories = "";


            string Query = "";
            if (Reference != "")
            {
                References = " and CO.Reference ='" + Reference + "' ";
            }
            if (Contact != 0)
            {
                Contacts = " and CO.Contact =" + Contact + " ";
            }
            if (Warehouse != 0)
            {
                Warehouses = " and CO.Warehouse =" + Warehouse + " ";
            }
            if (User != 0)
            {
                Users = " and CO.CreatedBy =" + User + " ";
            }
            if (User != 0)
            {
                Users = " and CO.CreatedBy =" + User + " ";
            }
            if (Category != 0)
            {
                Categories = " and I.CategoryId =" + Category + " ";
            }
            Query = "where 1=1 and Cast(CO.CheckoutDate as date)>=cast('" + StartDate.ToString("MM/dd/yyyy") + "' as date ) and Cast(CO.CheckoutDate as date)<=cast('" + EndDate.ToString("MM/dd/yyyy") + "' as date )" +
                " and  Cast(CO.CreatedDate as date)>=cast('" + StartCreatedDate.ToString("MM/dd/yyyy") + "' as date ) and Cast(CO.CreatedDate as date)<=cast('" + EndCreatedDate.ToString("MM/dd/yyyy") + "' as date ) " + References + " " +
                " " + Contacts + " " + Warehouses + " " + Users + " " + Categories + " and CO.draft ='" + draft + "'";

            CheckoutList = DB.CheckoutReportData(Query).ToList();

            return View(CheckoutList);
        }


        public ActionResult TransferReport()
        {
            List<TransferReportData_Result> TransferList = new List<TransferReportData_Result>();
            ViewBag.Contacts = DB.tblContacts.ToList();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
            ViewBag.Users = DB.tblUsers.ToList();
            ViewBag.Categories = DB.tblCategories.ToList();

            ViewBag.StartDate = DateTime.Now.ToString("yyyy-MM-dd");
            ViewBag.EndDate = DateTime.Now.ToString("yyyy-MM-dd");
            ViewBag.StartCreatedDate = DateTime.Now.ToString("yyyy-MM-dd");
            ViewBag.EndCreatedDate = DateTime.Now.ToString("yyyy-MM-dd");
            ViewBag.Reference = "";
            ViewBag.FromWarehouse = 0;
            ViewBag.ToWarehouse = 0;
            ViewBag.User = 0;
            ViewBag.Category = 0;
            ViewBag.draft = false;

            string Query = "";
            Query = "where 1=1 ";

            TransferList = DB.TransferReportData(Query).ToList();

            return View(TransferList);
        }

        [HttpPost]
        public ActionResult TransferReport(DateTime StartDate, DateTime EndDate, DateTime StartCreatedDate, DateTime EndCreatedDate, string Reference, int FromWarehouse = 0, int ToWarehouse = 0, int User = 0, int Category = 0, bool draft = false)
        {
            List<TransferReportData_Result> TransferList = new List<TransferReportData_Result>();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
            ViewBag.Users = DB.tblUsers.ToList();
            ViewBag.Categories = DB.tblCategories.ToList();

            ViewBag.StartDate = StartDate.ToString("yyyy-MM-dd");
            ViewBag.EndDate = EndDate.ToString("yyyy-MM-dd");
            ViewBag.StartCreatedDate = StartCreatedDate.ToString("yyyy-MM-dd");
            ViewBag.EndCreatedDate = EndCreatedDate.ToString("yyyy-MM-dd");
            ViewBag.Reference = Reference;
            ViewBag.FromWarehouse = FromWarehouse;
            ViewBag.ToWarehouse = ToWarehouse;
            ViewBag.User = User;
            ViewBag.Category = Category;
            ViewBag.draft = draft;

            string References = "";
            string FromWarehouses = "";
            string ToWarehouses = "";
            string Users = "";
            string Categories = "";


            string Query = "";
            if (Reference != "")
            {
                References = " and T.Reference ='" + Reference + "' ";
            }
            if (FromWarehouse != 0)
            {
                FromWarehouses = " and T.FromWarehouse =" + FromWarehouse + " ";
            }
            if (ToWarehouse != 0)
            {
                ToWarehouses = " and T.ToWarehouse =" + ToWarehouse + " ";
            }
            if (User != 0)
            {
                Users = " and T.CreatedBy =" + User + " ";
            }
            if (User != 0)
            {
                Users = " and T.CreatedBy =" + User + " ";
            }
            if (Category != 0)
            {
                Categories = " and I.CategoryId =" + Category + " ";
            }
            Query = "where 1=1 and Cast(T.TransferDate as date)>=cast('" + StartDate.ToString("MM/dd/yyyy") + "' as date ) and Cast(T.TransferDate as date)<=cast('" + EndDate.ToString("MM/dd/yyyy") + "' as date )" +
                " and  Cast(T.CreatedDate as date)>=cast('" + StartCreatedDate.ToString("MM/dd/yyyy") + "' as date ) and Cast(T.CreatedDate as date)<=cast('" + EndCreatedDate.ToString("MM/dd/yyyy") + "' as date ) " + References + " " +
                " " + FromWarehouses + " " + ToWarehouses + " " + Users + " " + Categories + " and T.draft ='" + draft + "'";

            TransferList = DB.TransferReportData(Query).ToList();

            return View(TransferList);
        }

        public ActionResult AdjustmentReport()
        {
            List<AdjustmentReportData_Result> AdjustmentList = new List<AdjustmentReportData_Result>();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
            ViewBag.Users = DB.tblUsers.ToList();
            ViewBag.Categories = DB.tblCategories.ToList();

            ViewBag.StartDate = DateTime.Now.ToString("yyyy-MM-dd");
            ViewBag.EndDate = DateTime.Now.ToString("yyyy-MM-dd");
            ViewBag.StartCreatedDate = DateTime.Now.ToString("yyyy-MM-dd");
            ViewBag.EndCreatedDate = DateTime.Now.ToString("yyyy-MM-dd");
            ViewBag.Reference = "";
            ViewBag.Warehouse = 0;
            ViewBag.User = 0;
            ViewBag.Category = 0;
            ViewBag.draft = false;

            string Query = "";
            Query = "where 1=1 ";

            AdjustmentList = DB.AdjustmentReportData(Query).ToList();

            return View(AdjustmentList);
        }

        [HttpPost]
        public ActionResult AdjustmentReport(DateTime StartDate, DateTime EndDate, DateTime StartCreatedDate, DateTime EndCreatedDate, string Reference, int Warehouse = 0, int User = 0, int Category = 0, bool draft = false)
        {
            List<AdjustmentReportData_Result> AdjustmentList = new List<AdjustmentReportData_Result>();
            ViewBag.Contacts = DB.tblContacts.ToList();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
            ViewBag.Users = DB.tblUsers.ToList();
            ViewBag.Categories = DB.tblCategories.ToList();

            ViewBag.StartDate = StartDate.ToString("yyyy-MM-dd");
            ViewBag.EndDate = EndDate.ToString("yyyy-MM-dd");
            ViewBag.StartCreatedDate = StartCreatedDate.ToString("yyyy-MM-dd");
            ViewBag.EndCreatedDate = EndCreatedDate.ToString("yyyy-MM-dd");
            ViewBag.Reference = Reference;
            ViewBag.Warehouse = Warehouse;
            ViewBag.User = User;
            ViewBag.Category = Category;
            ViewBag.draft = draft;

            string References = "";
            string Warehouses = "";
            string Users = "";
            string Categories = "";


            string Query = "";
            if (Reference != "")
            {
                References = " and A.Reference ='" + Reference + "' ";
            }
            if (Warehouse != 0)
            {
                Warehouses = " and A.Warehouse =" + Warehouse + " ";
            }
            if (User != 0)
            {
                Users = " and A.CreatedBy =" + User + " ";
            }
            if (User != 0)
            {
                Users = " and A.CreatedBy =" + User + " ";
            }
            if (Category != 0)
            {
                Categories = " and I.CategoryId =" + Category + " ";
            }
            Query = "where 1=1 and Cast(A.AdjustmentDate as date)>=cast('" + StartDate.ToString("MM/dd/yyyy") + "' as date ) and Cast(A.AdjustmentDate as date)<=cast('" + EndDate.ToString("MM/dd/yyyy") + "' as date )" +
                " and  Cast(A.CreatedDate as date)>=cast('" + StartCreatedDate.ToString("MM/dd/yyyy") + "' as date ) and Cast(A.CreatedDate as date)<=cast('" + EndCreatedDate.ToString("MM/dd/yyyy") + "' as date ) " + References + " " +
                "  " + Warehouses + " " + Users + " " + Categories + " and A.draft ='" + draft + "'";

            AdjustmentList = DB.AdjustmentReportData(Query).ToList();

            return View(AdjustmentList);
        }

        public ActionResult ItemStockLedgerReport()
        {
            List<ItemStockLedgerReportData_Result> ItemStockLedger = new List<ItemStockLedgerReportData_Result>();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
            ViewBag.Items = DB.tblItems.ToList();
            ViewBag.Categories = DB.tblCategories.ToList();

            
            ViewBag.Warehouse = 0;
            ViewBag.Item = 0;
            ViewBag.Category = 0;
            ViewBag.draft = false;

            string Query = "";
            string TQuery = "";
            string AQuery = "";
            Query = "where 1=1 ";
            TQuery = "where 1=1 ";
            AQuery = "where 1=1 ";

            ItemStockLedger = DB.ItemStockLedgerReportData(Query,TQuery,AQuery).ToList();

            return View(ItemStockLedger);
        }

        [HttpPost]
        public ActionResult ItemStockLedgerReport(int Warehouse = 0, int Item = 0, int Category = 0)
        {
            List<ItemStockLedgerReportData_Result> ItemStockLedger = new List<ItemStockLedgerReportData_Result>();
            ViewBag.Contacts = DB.tblContacts.ToList();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).ToList();
            ViewBag.Items = DB.tblItems.ToList();
            ViewBag.Categories = DB.tblCategories.ToList();

            
            ViewBag.Warehouse = Warehouse;
            ViewBag.Item = Item;
            ViewBag.Category = Category;

            string Warehouses = "";
            string Items = "";
            string Categories = "";


            string Query = "";
            string TQuery = "";
            string AQuery = "";
            if (Warehouse != 0)
            {
                Warehouses = " and CI.Warehouse =" + Warehouse + " ";
            }
            if (Item != 0)
            {
                Items = " and CII.ItemId =" + Item + " ";
            }
            if (Category != 0)
            {
                Categories = " and I.CategoryId =" + Category + " ";
            }
            Query = "where 1=1   "  + Warehouses + " " + Items + " " + Categories +" ";
             Warehouses = "";
             Items = "";
             Categories = "";
            if (Warehouse != 0)
            {
                Warehouses = " and T.ToWarehouse =" + Warehouse + " ";
            }
            if (Item != 0)
            {
                Items = " and TI.ItemId =" + Item + " ";
            }
            if (Category != 0)
            {
                Categories = " and I.CategoryId =" + Category + " ";
            }
            TQuery = "where 1=1   "  + Warehouses + " " + Items + " " + Categories +" ";
             Warehouses = "";
             Items = "";
             Categories = "";
            if (Warehouse != 0)
            {
                Warehouses = " and A.Warehouse =" + Warehouse + " ";
            }
            if (Item != 0)
            {
                Items = " and AI.ItemId =" + Item + " ";
            }
            if (Category != 0)
            {
                Categories = " and I.CategoryId =" + Category + " ";
            }
            AQuery = "where 1=1   "  + Warehouses + " " + Items + " " + Categories +"' ";

            ItemStockLedger = DB.ItemStockLedgerReportData(Query,TQuery,AQuery).ToList();

            return View(ItemStockLedger);
        }


        public ActionResult ItemStockLedgerDetailReport(int ItemId,int WarehouseId)
        {
            List<ItemStockLedgerDetailReportData_Result1> ItemStockLedger = new List<ItemStockLedgerDetailReportData_Result1>();

            ItemStockLedger = DB.ItemStockLedgerDetailReportData(ItemId, WarehouseId).ToList();

            return View(ItemStockLedger);
        }

        public ActionResult TotalRecord()
        {
            List<AdjustmentReportData_Result> AdjustmentList = new List<AdjustmentReportData_Result>();
            ViewBag.Items = DB.tblItems.Count();
            ViewBag.Contacts = DB.tblContacts.Count();
            ViewBag.Categories = DB.tblCategories.Count();
            ViewBag.Warehouses = DB.tblWarehouses.Where(x => x.isActive == true).Count();
            ViewBag.Checkins = DB.tblCheckins.Count();
            ViewBag.Checkouts = DB.tblCheckouts.Count();
            ViewBag.Transfers = DB.tblTransfers.Count();
            ViewBag.Adjustments = DB.tblAdjustments.Count();
            ViewBag.Units = DB.tblUnits.Count();
            ViewBag.Users = DB.tblUsers.Count();
            ViewBag.Roles = DB.tblRoles.Count();

            

            return View();
        }

    }
}