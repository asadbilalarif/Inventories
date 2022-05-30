using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Inventories.Models
{
    public class PCheckoutItem
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
        public Nullable<int> CheckinItemId { get; set; }
        public bool Deleted { get; set; }
        public string Number { get; set; }
    }
}