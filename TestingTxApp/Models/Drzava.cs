using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class Drzava
    {
        public Drzava()
        {
            Grads = new HashSet<Grad>();
            Ucesniks = new HashSet<Ucesnik>();
        }

        public string Oznaka { get; set; }
        public string Naziv { get; set; }

        public virtual ICollection<Grad> Grads { get; set; }
        public virtual ICollection<Ucesnik> Ucesniks { get; set; }
    }
}
