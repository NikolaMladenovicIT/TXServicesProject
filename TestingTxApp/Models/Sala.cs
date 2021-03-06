using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class Sala
    {
        public Sala()
        {
            Izlaganjes = new HashSet<Izlaganje>();
            OdrzavaSes = new HashSet<OdrzavaSe>();
        }

        public int IdSale { get; set; }
        public string Naziv { get; set; }
        public string Adresa { get; set; }
        public decimal? Kapacitet { get; set; }
        public string Ozvucena { get; set; }
        public string IdGrada { get; set; }

        public virtual Grad IdGradaNavigation { get; set; }
        public virtual ICollection<Izlaganje> Izlaganjes { get; set; }
        public virtual ICollection<OdrzavaSe> OdrzavaSes { get; set; }
    }
}
