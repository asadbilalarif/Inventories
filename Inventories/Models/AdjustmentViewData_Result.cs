//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Inventories.Models
{
    using System;
    
    public partial class AdjustmentViewData_Result
    {
        public int AdjustmentId { get; set; }
        public string AdjustmentNumber { get; set; }
        public System.DateTime AdjustmentDate { get; set; }
        public string Reference { get; set; }
        public string Type { get; set; }
        public Nullable<int> Warehouse { get; set; }
        public string Attachment { get; set; }
        public string Details { get; set; }
        public Nullable<bool> draft { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> EditBy { get; set; }
        public Nullable<System.DateTime> EditDate { get; set; }
        public Nullable<bool> isActive { get; set; }
        public string WarehouseName { get; set; }
        public string WarehouseAddress { get; set; }
        public string WarehouseEmail { get; set; }
        public string WarehousePhone { get; set; }
        public string ItemName { get; set; }
        public Nullable<int> ItemQuantity { get; set; }
    }
}