﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class InventoriesEntities : DbContext
    {
        public InventoriesEntities()
            : base("name=InventoriesEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<tblUser> tblUsers { get; set; }
        public virtual DbSet<tblAccessLevel> tblAccessLevels { get; set; }
        public virtual DbSet<tblMenu> tblMenus { get; set; }
        public virtual DbSet<tblRole> tblRoles { get; set; }
        public virtual DbSet<tblContact> tblContacts { get; set; }
        public virtual DbSet<tblCategory> tblCategories { get; set; }
        public virtual DbSet<tblUnit> tblUnits { get; set; }
        public virtual DbSet<tblWarehouse> tblWarehouses { get; set; }
        public virtual DbSet<tblItem> tblItems { get; set; }
        public virtual DbSet<tblTransfer> tblTransfers { get; set; }
        public virtual DbSet<tblTransferItem> tblTransferItems { get; set; }
        public virtual DbSet<tblTempPath> tblTempPaths { get; set; }
        public virtual DbSet<tblCheckin> tblCheckins { get; set; }
        public virtual DbSet<tblCheckinItem> tblCheckinItems { get; set; }
        public virtual DbSet<tblCheckout> tblCheckouts { get; set; }
        public virtual DbSet<tblCheckoutItem> tblCheckoutItems { get; set; }
        public virtual DbSet<tblAdjustment> tblAdjustments { get; set; }
        public virtual DbSet<tblAdjustmentItem> tblAdjustmentItems { get; set; }
    
        public virtual ObjectResult<string> TransfrNumber()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("TransfrNumber");
        }
    
        public virtual ObjectResult<string> CheckinNumber()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("CheckinNumber");
        }
    
        public virtual ObjectResult<string> CheckoutNumber()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("CheckoutNumber");
        }
    
        public virtual ObjectResult<string> AdjustmentNumber()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("AdjustmentNumber");
        }
    }
}
