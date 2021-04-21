using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class Konferencija
    {
        public Konferencija()
        {
            OdrzavaSes = new HashSet<OdrzavaSe>();
        }

        public int IdBroj { get; set; }
        public string Naziv { get; set; }
        public DateTime DatPocetka { get; set; }
        public DateTime DatZavrsetka { get; set; }
        public int IdOrganizatora { get; set; }

        public virtual Organizator IdOrganizatoraNavigation { get; set; }
        public virtual ICollection<OdrzavaSe> OdrzavaSes { get; set; }
    }
}
