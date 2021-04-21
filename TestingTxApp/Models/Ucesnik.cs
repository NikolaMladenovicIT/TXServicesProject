using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class Ucesnik
    {
        public Ucesnik()
        {
            AutorRadas = new HashSet<AutorRada>();
        }

        public int IdUcesnika { get; set; }
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public string Institucija { get; set; }
        public string Telefon { get; set; }
        public string EMail { get; set; }
        public string OznakaDrzave { get; set; }

        public virtual Drzava OznakaDrzaveNavigation { get; set; }
        public virtual ICollection<AutorRada> AutorRadas { get; set; }
    }
}
