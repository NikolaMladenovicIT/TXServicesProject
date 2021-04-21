using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class Organizator
    {
        public Organizator()
        {
            Konferencijas = new HashSet<Konferencija>();
        }

        public int IdOrganizatora { get; set; }
        public string Naziv { get; set; }
        public string AdresaSedista { get; set; }
        public string IdGrada { get; set; }

        public virtual Grad IdGradaNavigation { get; set; }
        public virtual ICollection<Konferencija> Konferencijas { get; set; }
    }
}
