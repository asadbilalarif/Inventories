using Inventories.Models;
using Rotativa;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Inventories.Controllers
{
    public class PDFController : Controller
    {
        // GET: PDF
        InventoriesEntities DB = new InventoriesEntities();
        public ActionResult ViewCheckinPDF(int Id)
        {
            List<CheckinViewData_Result2> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.CheckinViewData(Id).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View(allsearch);
        }
        public ActionResult PrintCheckinViewDataToPdf(int Id)
        {
            return new ActionAsPdf("ViewCheckinPDF", new { Id = Id })
            {
                FileName = "Checkin_Pdf.pdf"
            };
        }
        public ActionResult ViewCheckoutPDF(int Id)
        {
            List<CheckoutViewData_Result> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.CheckoutViewData(Id).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View(allsearch);
        }
        public ActionResult PrintCheckoutViewDataToPdf(int Id)
        {
            return new ActionAsPdf("ViewCheckoutPDF", new { Id = Id })
            {
                FileName = "Checkout_Pdf.pdf"
            };
        }
        public ActionResult ViewTransferPDF(int Id)
        {
            List<TransferViewData_Result> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.TransferViewData(Id).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View(allsearch);
        }
        public ActionResult PrintTransferViewDataToPdf(int Id)
        {
            return new ActionAsPdf("ViewTransferPDF", new { Id = Id })
            {
                FileName = "Transfer_Pdf.pdf"
            };
        }
        public ActionResult ViewAdjustmentPDF(int Id)
        {
            List<AdjustmentViewData_Result> allsearch = null;
            DB.Configuration.ProxyCreationEnabled = false;
            try
            {
                allsearch = DB.AdjustmentViewData(Id).ToList();

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                Console.WriteLine("Error" + ex.Message);
            }

            return View(allsearch);
        }
        public ActionResult PrintAdjustmentViewDataToPdf(int Id)
        {
            return new ActionAsPdf("ViewAdjustmentPDF", new { Id = Id })
            {
                FileName = "Adjustment_Pdf.pdf"
            };
        }
        public ActionResult ViewItemStockLedgerPDF(int ItemId, int WarehouseId)
        {
            List<ItemStockLedgerDetailReportData_Result1> ItemStockLedger = new List<ItemStockLedgerDetailReportData_Result1>();

            ItemStockLedger = DB.ItemStockLedgerDetailReportData(ItemId, WarehouseId).ToList();

            return View(ItemStockLedger);
        }
        public ActionResult PrintItemStockLedgerViewDataToPdf(int ItemId, int WarehouseId)
        {
            return new ActionAsPdf("ViewItemStockLedgerPDF", new { ItemId = ItemId, WarehouseId= WarehouseId })
            {
                FileName = "ItemStockLedger_Pdf.pdf"
            };
        }
    }
}