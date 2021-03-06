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
    using System.Collections.Generic;
    
    public partial class tblCheckin
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public tblCheckin()
        {
            this.tblCheckinItems = new HashSet<tblCheckinItem>();
        }
    
        public int CheckinId { get; set; }
        public System.DateTime CheckinDate { get; set; }
        public string Reference { get; set; }
        public Nullable<int> Contact { get; set; }
        public Nullable<int> Warehouse { get; set; }
        public string Attachment { get; set; }
        public string Details { get; set; }
        public Nullable<bool> draft { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> EditBy { get; set; }
        public Nullable<System.DateTime> EditDate { get; set; }
        public Nullable<bool> isActive { get; set; }
        public string CheckinNumber { get; set; }
        public string QRCode { get; set; }
        public string BarCode { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tblCheckinItem> tblCheckinItems { get; set; }
        public virtual tblContact tblContact { get; set; }
        public virtual tblWarehouse tblWarehouse { get; set; }
    }
}
