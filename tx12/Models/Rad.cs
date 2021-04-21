using System;
using System.Collections.Generic;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class Rad
    {
        public Rad()
        {
            AutorRadas = new HashSet<AutorRada>();
        }

        public int BrRada { get; set; }
        public string Naziv { get; set; }
        public string Oblast { get; set; }
        public decimal Obim { get; set; }
        public decimal KatZnacaj { get; set; }

        public virtual ICollection<AutorRada> AutorRadas { get; set; }
    }
}
