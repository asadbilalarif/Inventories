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
    
    public partial class TransferReportData_Result
    {
        public int TransferId { get; set; }
        public string TransferNumber { get; set; }
        public System.DateTime TransferDate { get; set; }
        public string Reference { get; set; }
        public Nullable<int> FromWarehouse { get; set; }
        public Nullable<int> ToWarehouse { get; set; }
        public string Attachment { get; set; }
        public string Details { get; set; }
        public Nullable<bool> draft { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> EditBy { get; set; }
        public Nullable<System.DateTime> EditDate { get; set; }
        public Nullable<bool> isActive { get; set; }
        public string FromWarehouseName { get; set; }
        public string ToWarehouseName { get; set; }
        public string UserName { get; set; }
    }
}