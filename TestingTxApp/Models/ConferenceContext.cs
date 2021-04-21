using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace tx12.Models
{
    public partial class ConferenceContext : DbContext
    {
        public ConferenceContext()
        {
        }

        public ConferenceContext(DbContextOptions<ConferenceContext> options)
            : base(options)
        {
        }

        public virtual DbSet<AutorRada> AutorRadas { get; set; }
        public virtual DbSet<Drzava> Drzavas { get; set; }
        public virtual DbSet<Grad> Grads { get; set; }
        public virtual DbSet<Izlaganje> Izlaganjes { get; set; }
        public virtual DbSet<Konferencija> Konferencijas { get; set; }
        public virtual DbSet<OdrzavaSe> OdrzavaSes { get; set; }
        public virtual DbSet<Organizator> Organizators { get; set; }
        public virtual DbSet<Rad> Rads { get; set; }
        public virtual DbSet<Sala> Salas { get; set; }
        public virtual DbSet<Ucesnik> Ucesniks { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Name=KonferencijaDB");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AutorRada>(entity =>
            {
                entity.HasKey(e => new { e.BrRada, e.IdUcesnika })
                    .HasName("PK__Autor_Ra__D35ED104381645A5");

                entity.ToTable("Autor_Rada");

                entity.Property(e => e.IdUcesnika).HasColumnName("ID_Ucesnika");

                entity.HasOne(d => d.BrRadaNavigation)
                    .WithMany(p => p.AutorRadas)
                    .HasForeignKey(d => d.BrRada)
                    .HasConstraintName("FK__Autor_Rad__BrRad__3B75D760");

                entity.HasOne(d => d.IdUcesnikaNavigation)
                    .WithMany(p => p.AutorRadas)
                    .HasForeignKey(d => d.IdUcesnika)
                    .HasConstraintName("FK__Autor_Rad__ID_Uc__3C69FB99");
            });

            modelBuilder.Entity<Drzava>(entity =>
            {
                entity.HasKey(e => e.Oznaka)
                    .HasName("PK__Drzava__F642A30FB6BB7E30");

                entity.ToTable("Drzava");

                entity.Property(e => e.Oznaka)
                    .HasMaxLength(3)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.Naziv)
                    .IsRequired()
                    .HasMaxLength(120)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Grad>(entity =>
            {
                entity.HasKey(e => e.Ptt)
                    .HasName("PK__Grad__C5733DCD962FC35F");

                entity.ToTable("Grad");

                entity.Property(e => e.Ptt)
                    .HasColumnName("PTT")
                    .HasMaxLength(9)
                    .IsUnicode(false);

                entity.Property(e => e.Naziv)
                    .IsRequired()
                    .HasMaxLength(40)
                    .IsUnicode(false);

                entity.Property(e => e.OznakaDrzave)
                    .IsRequired()
                    .HasColumnName("Oznaka_Drzave")
                    .HasMaxLength(3)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.HasOne(d => d.OznakaDrzaveNavigation)
                    .WithMany(p => p.Grads)
                    .HasForeignKey(d => d.OznakaDrzave)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Grad__Oznaka_Drz__2B3F6F97");
            });

            modelBuilder.Entity<Izlaganje>(entity =>
            {
                entity.HasKey(e => new { e.IdSale, e.BrRada, e.IdUcesnika, e.DatumVreme })
                    .HasName("PK__Izlaganj__724111FDC7FB8D15");

                entity.ToTable("Izlaganje");

                entity.Property(e => e.IdSale).HasColumnName("ID_Sale");

                entity.Property(e => e.IdUcesnika).HasColumnName("ID_Ucesnika");

                entity.Property(e => e.DatumVreme).HasColumnType("datetime");

                entity.Property(e => e.TipSesije)
                    .IsRequired()
                    .HasMaxLength(8)
                    .IsUnicode(false);

                entity.HasOne(d => d.IdSaleNavigation)
                    .WithMany(p => p.Izlaganjes)
                    .HasForeignKey(d => d.IdSale)
                    .HasConstraintName("FK__Izlaganje__ID_Sa__403A8C7D");

                entity.HasOne(d => d.AutorRada)
                    .WithMany(p => p.Izlaganjes)
                    .HasForeignKey(d => new { d.BrRada, d.IdUcesnika })
                    .HasConstraintName("FK__Izlaganje__412EB0B6");
            });

            modelBuilder.Entity<Konferencija>(entity =>
            {
                entity.HasKey(e => e.IdBroj)
                    .HasName("PK__Konferen__DFC7EBB4238DFD94");

                entity.ToTable("Konferencija");

                entity.Property(e => e.IdBroj)
                    .HasColumnName("ID_Broj")
                    .ValueGeneratedNever();

                entity.Property(e => e.DatPocetka).HasColumnType("date");

                entity.Property(e => e.DatZavrsetka).HasColumnType("date");

                entity.Property(e => e.IdOrganizatora).HasColumnName("ID_Organizatora");

                entity.Property(e => e.Naziv)
                    .IsRequired()
                    .HasMaxLength(80)
                    .IsUnicode(false);

                entity.HasOne(d => d.IdOrganizatoraNavigation)
                    .WithMany(p => p.Konferencijas)
                    .HasForeignKey(d => d.IdOrganizatora)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Konferenc__ID_Or__34C8D9D1");
            });

            modelBuilder.Entity<OdrzavaSe>(entity =>
            {
                entity.HasKey(e => new { e.IdBroj, e.IdSale })
                    .HasName("PK__Odrzava___FDC0F65E1C314C2B");

                entity.ToTable("Odrzava_Se");

                entity.Property(e => e.IdBroj).HasColumnName("ID_Broj");

                entity.Property(e => e.IdSale).HasColumnName("ID_Sale");

                entity.HasOne(d => d.IdBrojNavigation)
                    .WithMany(p => p.OdrzavaSes)
                    .HasForeignKey(d => d.IdBroj)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Odrzava_S__ID_Br__37A5467C");

                entity.HasOne(d => d.IdSaleNavigation)
                    .WithMany(p => p.OdrzavaSes)
                    .HasForeignKey(d => d.IdSale)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Odrzava_S__ID_Sa__38996AB5");
            });

            modelBuilder.Entity<Organizator>(entity =>
            {
                entity.HasKey(e => e.IdOrganizatora)
                    .HasName("PK__Organiza__7777E8B7A44367DD");

                entity.ToTable("Organizator");

                entity.Property(e => e.IdOrganizatora)
                    .HasColumnName("ID_Organizatora")
                    .ValueGeneratedNever();

                entity.Property(e => e.AdresaSedista)
                    .IsRequired()
                    .HasColumnName("Adresa_sedista")
                    .HasMaxLength(80)
                    .IsUnicode(false);

                entity.Property(e => e.IdGrada)
                    .IsRequired()
                    .HasColumnName("ID_Grada")
                    .HasMaxLength(9)
                    .IsUnicode(false);

                entity.Property(e => e.Naziv)
                    .IsRequired()
                    .HasMaxLength(40)
                    .IsUnicode(false);

                entity.HasOne(d => d.IdGradaNavigation)
                    .WithMany(p => p.Organizators)
                    .HasForeignKey(d => d.IdGrada)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Organizat__ID_Gr__2E1BDC42");
            });

            modelBuilder.Entity<Rad>(entity =>
            {
                entity.HasKey(e => e.BrRada)
                    .HasName("PK__Rad__B431EF5DCF22572F");

                entity.ToTable("Rad");

                entity.Property(e => e.KatZnacaj).HasColumnType("numeric(3, 0)");

                entity.Property(e => e.Naziv)
                    .IsRequired()
                    .HasMaxLength(160)
                    .IsUnicode(false);

                entity.Property(e => e.Obim).HasColumnType("numeric(3, 0)");

                entity.Property(e => e.Oblast)
                    .HasMaxLength(50)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Sala>(entity =>
            {
                entity.HasKey(e => e.IdSale)
                    .HasName("PK__Sala__2071DEA360867381");

                entity.ToTable("Sala");

                entity.Property(e => e.IdSale).HasColumnName("ID_Sale");

                entity.Property(e => e.Adresa)
                    .IsRequired()
                    .HasMaxLength(80)
                    .IsUnicode(false);

                entity.Property(e => e.IdGrada)
                    .IsRequired()
                    .HasColumnName("ID_Grada")
                    .HasMaxLength(9)
                    .IsUnicode(false);

                entity.Property(e => e.Kapacitet).HasColumnType("numeric(5, 0)");

                entity.Property(e => e.Naziv)
                    .IsRequired()
                    .HasMaxLength(40)
                    .IsUnicode(false);

                entity.Property(e => e.Ozvucena)
                    .IsRequired()
                    .HasMaxLength(2)
                    .IsUnicode(false);

                entity.HasOne(d => d.IdGradaNavigation)
                    .WithMany(p => p.Salas)
                    .HasForeignKey(d => d.IdGrada)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Sala__ID_Grada__31EC6D26");
            });

            modelBuilder.Entity<Ucesnik>(entity =>
            {
                entity.HasKey(e => e.IdUcesnika)
                    .HasName("PK__Ucesnik__76F3E59774F0412C");

                entity.ToTable("Ucesnik");

                entity.Property(e => e.IdUcesnika).HasColumnName("ID_Ucesnika");

                entity.Property(e => e.EMail)
                    .HasColumnName("eMail")
                    .HasMaxLength(40)
                    .IsUnicode(false);

                entity.Property(e => e.Ime)
                    .IsRequired()
                    .HasMaxLength(40)
                    .IsUnicode(false);

                entity.Property(e => e.Institucija)
                    .HasMaxLength(80)
                    .IsUnicode(false);

                entity.Property(e => e.OznakaDrzave)
                    .IsRequired()
                    .HasColumnName("Oznaka_Drzave")
                    .HasMaxLength(3)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.Prezime)
                    .IsRequired()
                    .HasMaxLength(40)
                    .IsUnicode(false);

                entity.Property(e => e.Telefon)
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.HasOne(d => d.OznakaDrzaveNavigation)
                    .WithMany(p => p.Ucesniks)
                    .HasForeignKey(d => d.OznakaDrzave)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Ucesnik__Oznaka___286302EC");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
