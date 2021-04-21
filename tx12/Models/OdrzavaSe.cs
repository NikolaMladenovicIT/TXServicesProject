using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class OdrzavaSe
    {
        public int IdBroj { get; set; }
        public int IdSale { get; set; }

        public virtual Konferencija IdBrojNavigation { get; set; }
        public virtual Sala IdSaleNavigation { get; set; }
    }
}
