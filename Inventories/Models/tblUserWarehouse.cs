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
    
    public partial class tblUserWarehouse
    {
        public int UserWarehouseId { get; set; }
        public Nullable<int> UserId { get; set; }
        public Nullable<int> WarehouseId { get; set; }
    
        public virtual tblUser tblUser { get; set; }
        public virtual tblWarehouse tblWarehouse { get; set; }
    }
}
