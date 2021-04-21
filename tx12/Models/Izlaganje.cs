using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class Izlaganje
    {
        public int IdSale { get; set; }
        public int BrRada { get; set; }
        public int IdUcesnika { get; set; }
        public DateTime DatumVreme { get; set; }
        public string TipSesije { get; set; }

        public virtual AutorRada AutorRada { get; set; }
        public virtual Sala IdSaleNavigation { get; set; }
    }
}
