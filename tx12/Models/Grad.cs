using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class Grad
    {
        public Grad()
        {
            Organizators = new HashSet<Organizator>();
            Salas = new HashSet<Sala>();
        }

        public string Ptt { get; set; }
        public string Naziv { get; set; }
        public string OznakaDrzave { get; set; }

        public virtual Drzava OznakaDrzaveNavigation { get; set; }
        public virtual ICollection<Organizator> Organizators { get; set; }
        public virtual ICollection<Sala> Salas { get; set; }
    }
}
