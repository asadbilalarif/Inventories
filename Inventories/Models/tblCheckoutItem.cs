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
    
    public partial class tblCheckoutItem
    {
        public int CheckoutItemId { get; set; }
        public Nullable<int> CheckoutId { get; set; }
        public Nullable<int> ItemId { get; set; }
        public Nullable<int> ItemWeight { get; set; }
        public Nullable<int> ItemQuantity { get; set; }
        public string ItemUnit { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> EditBy { get; set; }
        public Nullable<System.DateTime> EditDate { get; set; }
        public Nullable<bool> isActive { get; set; }
    
        public virtual tblCheckout tblCheckout { get; set; }
        public virtual tblItem tblItem { get; set; }
    }
}