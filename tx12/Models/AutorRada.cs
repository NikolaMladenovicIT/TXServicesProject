using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class AutorRada
    {
        public AutorRada()
        {
            Izlaganjes = new HashSet<Izlaganje>();
        }

        public int BrRada { get; set; }
        public int IdUcesnika { get; set; }

        public virtual Rad BrRadaNavigation { get; set; }
        public virtual Ucesnik IdUcesnikaNavigation { get; set; }
        public virtual ICollection<Izlaganje> Izlaganjes { get; set; }
    }
}
