USE [Conference]
GO
/****** Object:  StoredProcedure [dbo].[PromenaSatniceIzlaganja]    Script Date: 4/21/2021 3:47:56 PM ******/
DROP PROCEDURE [dbo].[PromenaSatniceIzlaganja]
GO
/****** Object:  StoredProcedure [dbo].[Info_konferencija]    Script Date: 4/21/2021 3:47:56 PM ******/
DROP PROCEDURE [dbo].[Info_konferencija]
GO
ALTER TABLE [dbo].[Sala] DROP CONSTRAINT [OZ]
GO
ALTER TABLE [dbo].[Izlaganje] DROP CONSTRAINT [TS]
GO
ALTER TABLE [dbo].[Ucesnik] DROP CONSTRAINT [FK__Ucesnik__Oznaka___286302EC]
GO
ALTER TABLE [dbo].[Sala] DROP CONSTRAINT [FK__Sala__ID_Grada__31EC6D26]
GO
ALTER TABLE [dbo].[Organizator] DROP CONSTRAINT [FK__Organizat__ID_Gr__2E1BDC42]
GO
ALTER TABLE [dbo].[Odrzava_Se] DROP CONSTRAINT [FK__Odrzava_S__ID_Sa__38996AB5]
GO
ALTER TABLE [dbo].[Odrzava_Se] DROP CONSTRAINT [FK__Odrzava_S__ID_Br__71D1E811]
GO
ALTER TABLE [dbo].[Konferencija] DROP CONSTRAINT [FK__Konferenc__ID_Or__74AE54BC]
GO
ALTER TABLE [dbo].[Konferencija] DROP CONSTRAINT [FK__Konferenc__ID_Or__34C8D9D1]
GO
ALTER TABLE [dbo].[Izlaganje] DROP CONSTRAINT [FK__Izlaganje__ID_Sa__403A8C7D]
GO
ALTER TABLE [dbo].[Izlaganje] DROP CONSTRAINT [FK__Izlaganje__412EB0B6]
GO
ALTER TABLE [dbo].[Grad] DROP CONSTRAINT [FK__Grad__Oznaka_Drz__2B3F6F97]
GO
ALTER TABLE [dbo].[Autor_Rada] DROP CONSTRAINT [FK__Autor_Rad__ID_Uc__3C69FB99]
GO
ALTER TABLE [dbo].[Autor_Rada] DROP CONSTRAINT [FK__Autor_Rad__BrRad__3B75D760]
GO
/****** Object:  Table [dbo].[Organizator]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Organizator]') AND type in (N'U'))
DROP TABLE [dbo].[Organizator]
GO
/****** Object:  Table [dbo].[Odrzava_Se]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Odrzava_Se]') AND type in (N'U'))
DROP TABLE [dbo].[Odrzava_Se]
GO
/****** Object:  Table [dbo].[Konferencija]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Konferencija]') AND type in (N'U'))
DROP TABLE [dbo].[Konferencija]
GO
/****** Object:  View [dbo].[Pregled_Radova_po_Salama]    Script Date: 4/21/2021 3:47:56 PM ******/
DROP VIEW [dbo].[Pregled_Radova_po_Salama]
GO
/****** Object:  Table [dbo].[Grad]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Grad]') AND type in (N'U'))
DROP TABLE [dbo].[Grad]
GO
/****** Object:  UserDefinedFunction [dbo].[Ucesnici_Iz]    Script Date: 4/21/2021 3:47:56 PM ******/
DROP FUNCTION [dbo].[Ucesnici_Iz]
GO
/****** Object:  Table [dbo].[Rad]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rad]') AND type in (N'U'))
DROP TABLE [dbo].[Rad]
GO
/****** Object:  Table [dbo].[Sala]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sala]') AND type in (N'U'))
DROP TABLE [dbo].[Sala]
GO
/****** Object:  Table [dbo].[Ucesnik]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ucesnik]') AND type in (N'U'))
DROP TABLE [dbo].[Ucesnik]
GO
/****** Object:  Table [dbo].[Izlaganje]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Izlaganje]') AND type in (N'U'))
DROP TABLE [dbo].[Izlaganje]
GO
/****** Object:  Table [dbo].[Autor_Rada]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Autor_Rada]') AND type in (N'U'))
DROP TABLE [dbo].[Autor_Rada]
GO
/****** Object:  Table [dbo].[Drzava]    Script Date: 4/21/2021 3:47:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drzava]') AND type in (N'U'))
DROP TABLE [dbo].[Drzava]
GO
/****** Object:  UserDefinedFunction [dbo].[SatniceIzlaganja]    Script Date: 4/21/2021 3:47:56 PM ******/
DROP FUNCTION [dbo].[SatniceIzlaganja]
GO
/****** Object:  UserDefinedFunction [dbo].[SatniceIzlaganja]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SatniceIzlaganja](@Dan date, @brojSale int)
RETURNS @retIzvestaj TABLE
( Brojrada int NOT NULL,
NazivRada varchar(160) NOT NULL,
ImePrezime varchar(90),
StaroPlaniranoVreme datetime,
AktuelnoPlaniranoVreme datetime,
TipSesije varchar(8) NOT NULL
)
AS
BEGIN
WITH PrivremenaTabela (Brojrada, NazivRada, AutorImePrezime, StaroVreme, DatumVreme, TipSesije) AS (
SELECT DISTINCT I.BrRada, R.Naziv AS NazivRada, UC.Ime +' '+ UC.Prezime AS AutorImePrezime,
I.StaroVreme, I.DatumVreme, I.TipSesije
FROM Izlaganje AS I JOIN Autor_Rada AS AR on I.BrRada=AR.BrRada AND I.ID_Ucesnika =AR.ID_Ucesnika
JOIN Rad AS R ON R.BrRada= I.BrRada JOIN Ucesnik AS UC ON I.ID_Ucesnika = UC.ID_Ucesnika
WHERE CONVERT(date,I.DatumVreme) = CONVERT(date,@Dan) AND I.ID_Sale = @brojSale)
INSERT @retIzvestaj
SELECT Brojrada, NazivRada, AutorImePrezime, StaroVreme, DatumVreme, TipSesije
FROM PrivremenaTabela
RETURN
END;
GO
/****** Object:  Table [dbo].[Drzava]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drzava](
	[Oznaka] [char](3) NOT NULL,
	[Naziv] [varchar](120) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Oznaka] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Autor_Rada]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Autor_Rada](
	[BrRada] [int] NOT NULL,
	[ID_Ucesnika] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BrRada] ASC,
	[ID_Ucesnika] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Izlaganje]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Izlaganje](
	[ID_Sale] [int] NOT NULL,
	[BrRada] [int] NOT NULL,
	[ID_Ucesnika] [int] NOT NULL,
	[DatumVreme] [datetime] NOT NULL,
	[TipSesije] [varchar](8) NOT NULL,
	[StaroVreme] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Sale] ASC,
	[BrRada] ASC,
	[ID_Ucesnika] ASC,
	[DatumVreme] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ucesnik]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ucesnik](
	[ID_Ucesnika] [int] IDENTITY(1,1) NOT NULL,
	[Ime] [varchar](40) NOT NULL,
	[Prezime] [varchar](40) NOT NULL,
	[Institucija] [varchar](80) NULL,
	[Telefon] [varchar](30) NULL,
	[eMail] [varchar](40) NULL,
	[Oznaka_Drzave] [char](3) NOT NULL,
 CONSTRAINT [PK__Ucesnik__76F3E59774F0412C] PRIMARY KEY CLUSTERED 
(
	[ID_Ucesnika] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sala]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sala](
	[ID_Sale] [int] IDENTITY(1,1) NOT NULL,
	[Naziv] [varchar](40) NOT NULL,
	[Adresa] [varchar](80) NOT NULL,
	[Kapacitet] [numeric](5, 0) NULL,
	[Ozvucena] [varchar](2) NOT NULL,
	[ID_Grada] [varchar](9) NOT NULL,
 CONSTRAINT [PK__Sala__2071DEA360867381] PRIMARY KEY CLUSTERED 
(
	[ID_Sale] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rad]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rad](
	[BrRada] [int] IDENTITY(1,1) NOT NULL,
	[Naziv] [varchar](160) NOT NULL,
	[Oblast] [varchar](50) NULL,
	[Obim] [numeric](3, 0) NOT NULL,
	[KatZnacaj] [numeric](3, 0) NOT NULL,
 CONSTRAINT [PK__Rad__B431EF5DCF22572F] PRIMARY KEY CLUSTERED 
(
	[BrRada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Ucesnici_Iz]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Ucesnici_Iz](@drzava char(3))
RETURNS TABLE
AS
RETURN
( SELECT u.Ime, u.Prezime, u.Institucija, d.Naziv AS 'Država', r.Naziv AS 'Naziv rada',
r.Oblast,i.DatumVreme AS 'Datum i vreme izlaganja', s.Naziv AS 'Naziv_Sale'
FROM (Drzava AS d INNER JOIN Ucesnik AS u ON d.Oznaka = u.Oznaka_Drzave) LEFT JOIN
Autor_Rada AS a ON u.ID_Ucesnika = a.ID_Ucesnika INNER JOIN
Rad AS r ON a.BrRada = r.BrRada INNER JOIN
Izlaganje AS i ON a.BrRada = i.BrRada AND a.ID_Ucesnika =i.ID_Ucesnika LEFT JOIN
Sala as s ON i.ID_Sale = s.ID_Sale
WHERE d.Oznaka LIKE (SUBSTRING(@drzava,1,3) +'%') OR d.Naziv LIKE (SUBSTRING(@drzava,1,3) +'%')
);
GO
/****** Object:  Table [dbo].[Grad]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grad](
	[PTT] [varchar](9) NOT NULL,
	[Naziv] [varchar](40) NOT NULL,
	[Oznaka_Drzave] [char](3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PTT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Pregled_Radova_po_Salama]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Pregled_Radova_po_Salama]
AS
SELECT Rad.Naziv AS 'Naziv rada', Rad.Oblast, Ucesnik.Ime +' '+ Ucesnik.Prezime AS 'Ime Autora',
Ucesnik.Institucija, Ucesnik.eMail, Ucesnik.Telefon, Drzava.Naziv AS 'Država',
Izlaganje.DatumVreme as 'Datum i vreme izlaganja', Sala.Naziv AS Naziv_Sale, Sala.Adresa, Grad.Naziv, Grad.PTT
FROM (((Rad JOIN Autor_Rada ON Rad.BrRada = Autor_Rada.BrRada
JOIN Ucesnik ON Autor_Rada.ID_Ucesnika = Ucesnik.ID_Ucesnika JOIN Drzava ON Ucesnik.Oznaka_Drzave = Drzava.Oznaka)
JOIN Izlaganje ON Autor_Rada.BrRada = Izlaganje.BrRada
AND Autor_Rada.ID_Ucesnika = Izlaganje.ID_Ucesnika)
JOIN Sala ON Izlaganje.ID_Sale = Sala.ID_Sale)
JOIN Grad ON Sala.ID_Grada = Grad.PTT ;
GO
/****** Object:  Table [dbo].[Konferencija]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Konferencija](
	[ID_Broj] [int] NOT NULL,
	[Naziv] [varchar](80) NOT NULL,
	[DatPocetka] [date] NOT NULL,
	[DatZavrsetka] [date] NOT NULL,
	[ID_Organizatora] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Broj] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Odrzava_Se]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Odrzava_Se](
	[ID_Broj] [int] NOT NULL,
	[ID_Sale] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Broj] ASC,
	[ID_Sale] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organizator]    Script Date: 4/21/2021 3:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizator](
	[ID_Organizatora] [int] NOT NULL,
	[Naziv] [varchar](40) NOT NULL,
	[Adresa_sedista] [varchar](80) NOT NULL,
	[ID_Grada] [varchar](9) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Organizatora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Autor_Rada] ([BrRada], [ID_Ucesnika]) VALUES (1, 1)
INSERT [dbo].[Autor_Rada] ([BrRada], [ID_Ucesnika]) VALUES (2, 1)
INSERT [dbo].[Autor_Rada] ([BrRada], [ID_Ucesnika]) VALUES (3, 2)
GO
INSERT [dbo].[Drzava] ([Oznaka], [Naziv]) VALUES (N'BIH', N'Bosna i Hercegovina')
INSERT [dbo].[Drzava] ([Oznaka], [Naziv]) VALUES (N'CHN', N'Kina')
INSERT [dbo].[Drzava] ([Oznaka], [Naziv]) VALUES (N'CRO', N'Hrvatska')
INSERT [dbo].[Drzava] ([Oznaka], [Naziv]) VALUES (N'SRB', N'Srbija')
INSERT [dbo].[Drzava] ([Oznaka], [Naziv]) VALUES (N'USA', N'Sjedinjene Americke Države')
GO
INSERT [dbo].[Grad] ([PTT], [Naziv], [Oznaka_Drzave]) VALUES (N'11000', N'Beograd', N'SRB')
INSERT [dbo].[Grad] ([PTT], [Naziv], [Oznaka_Drzave]) VALUES (N'18000', N'Niš', N'SRB')
INSERT [dbo].[Grad] ([PTT], [Naziv], [Oznaka_Drzave]) VALUES (N'21000', N'Novi Sad', N'SRB')
INSERT [dbo].[Grad] ([PTT], [Naziv], [Oznaka_Drzave]) VALUES (N'36354', N'Kopaonik', N'SRB')
INSERT [dbo].[Grad] ([PTT], [Naziv], [Oznaka_Drzave]) VALUES (N'71423', N'Jahorina', N'BIH')
GO
INSERT [dbo].[Izlaganje] ([ID_Sale], [BrRada], [ID_Ucesnika], [DatumVreme], [TipSesije], [StaroVreme]) VALUES (1, 1, 1, CAST(N'2019-03-10T08:30:00.000' AS DateTime), N'Pozivna', NULL)
INSERT [dbo].[Izlaganje] ([ID_Sale], [BrRada], [ID_Ucesnika], [DatumVreme], [TipSesije], [StaroVreme]) VALUES (2, 3, 2, CAST(N'2019-11-23T08:15:00.000' AS DateTime), N'Pozivna', CAST(N'2019-11-23T08:30:00.000' AS DateTime))
INSERT [dbo].[Izlaganje] ([ID_Sale], [BrRada], [ID_Ucesnika], [DatumVreme], [TipSesije], [StaroVreme]) VALUES (3, 1, 1, CAST(N'2019-03-10T09:30:00.000' AS DateTime), N'Pozivna', NULL)
GO
INSERT [dbo].[Konferencija] ([ID_Broj], [Naziv], [DatPocetka], [DatZavrsetka], [ID_Organizatora]) VALUES (100, N'YUinfo2019', CAST(N'2019-03-10' AS Date), CAST(N'2019-03-13' AS Date), 100)
INSERT [dbo].[Konferencija] ([ID_Broj], [Naziv], [DatPocetka], [DatZavrsetka], [ID_Organizatora]) VALUES (101, N'ICIST2019', CAST(N'2019-03-10' AS Date), CAST(N'2019-03-13' AS Date), 100)
INSERT [dbo].[Konferencija] ([ID_Broj], [Naziv], [DatPocetka], [DatZavrsetka], [ID_Organizatora]) VALUES (102, N'INFOTEH-JAHORINA 2021', CAST(N'2019-03-20' AS Date), CAST(N'2019-03-22' AS Date), 101)
INSERT [dbo].[Konferencija] ([ID_Broj], [Naziv], [DatPocetka], [DatZavrsetka], [ID_Organizatora]) VALUES (103, N'TELFOR 2019', CAST(N'2019-11-23' AS Date), CAST(N'2019-11-25' AS Date), 101)
INSERT [dbo].[Konferencija] ([ID_Broj], [Naziv], [DatPocetka], [DatZavrsetka], [ID_Organizatora]) VALUES (104, N'ETRAN 2019', CAST(N'2019-06-03' AS Date), CAST(N'2019-06-06' AS Date), 102)
INSERT [dbo].[Konferencija] ([ID_Broj], [Naziv], [DatPocetka], [DatZavrsetka], [ID_Organizatora]) VALUES (105, N'Ee2019 20th International Symposium POWER ELECTRONICS,', CAST(N'2019-10-23' AS Date), CAST(N'2019-10-26' AS Date), 100)
GO
INSERT [dbo].[Organizator] ([ID_Organizatora], [Naziv], [Adresa_sedista], [ID_Grada]) VALUES (100, N'ITeam eventss', N'Tadeuša Košcuška 53', N'11000')
INSERT [dbo].[Organizator] ([ID_Organizatora], [Naziv], [Adresa_sedista], [ID_Grada]) VALUES (101, N'IEEE Serbia and Montenegro Section', N'FTN, Trg D. Obradovica 6', N'21000')
INSERT [dbo].[Organizator] ([ID_Organizatora], [Naziv], [Adresa_sedista], [ID_Grada]) VALUES (102, N'ETRAN', N'Kneza Miloša 9/IVV', N'11000')
INSERT [dbo].[Organizator] ([ID_Organizatora], [Naziv], [Adresa_sedista], [ID_Grada]) VALUES (103, N'SDFSociety', N'Mihajla Pupina 29/11', N'11000')
GO
SET IDENTITY_INSERT [dbo].[Rad] ON 

INSERT [dbo].[Rad] ([BrRada], [Naziv], [Oblast], [Obim], [KatZnacaj]) VALUES (1, N'Device-to-Device Communication Based IoT System: Benefits and
Challenges', N'Informatika - Racunarske mreže', CAST(15 AS Numeric(3, 0)), CAST(2 AS Numeric(3, 0)))
INSERT [dbo].[Rad] ([BrRada], [Naziv], [Oblast], [Obim], [KatZnacaj]) VALUES (2, N'Review of LiFi visible light communications: research and use cases', N'Informatika
- Racunarske mreže', CAST(16 AS Numeric(3, 0)), CAST(1 AS Numeric(3, 0)))
INSERT [dbo].[Rad] ([BrRada], [Naziv], [Oblast], [Obim], [KatZnacaj]) VALUES (3, N'Light fidelity (Li-Fi): towards all-optical networking', N'Informatika - Racunarske
mreže', CAST(22 AS Numeric(3, 0)), CAST(1 AS Numeric(3, 0)))
INSERT [dbo].[Rad] ([BrRada], [Naziv], [Oblast], [Obim], [KatZnacaj]) VALUES (4, N'Model of BigData implementation in education', N'Informatika - Racunarski
sistemi', CAST(12 AS Numeric(3, 0)), CAST(2 AS Numeric(3, 0)))
SET IDENTITY_INSERT [dbo].[Rad] OFF
GO
SET IDENTITY_INSERT [dbo].[Sala] ON 

INSERT [dbo].[Sala] ([ID_Sale], [Naziv], [Adresa], [Kapacitet], [Ozvucena], [ID_Grada]) VALUES (1, N'Kopaonik velika', N'Hotel Grand bb', CAST(280 AS Numeric(5, 0)), N'DA', N'36354')
INSERT [dbo].[Sala] ([ID_Sale], [Naziv], [Adresa], [Kapacitet], [Ozvucena], [ID_Grada]) VALUES (2, N'Jahorina1', N'Hotel Bistrik bb', CAST(220 AS Numeric(5, 0)), N'DA', N'71423')
INSERT [dbo].[Sala] ([ID_Sale], [Naziv], [Adresa], [Kapacitet], [Ozvucena], [ID_Grada]) VALUES (3, N'Anfiteatar1', N'ETF, Bulevar kralja Aleksandra 73', CAST(400 AS Numeric(5, 0)), N'DA', N'11000')
SET IDENTITY_INSERT [dbo].[Sala] OFF
GO
SET IDENTITY_INSERT [dbo].[Ucesnik] ON 

INSERT [dbo].[Ucesnik] ([ID_Ucesnika], [Ime], [Prezime], [Institucija], [Telefon], [eMail], [Oznaka_Drzave]) VALUES (1, N'Nikola', N'Mladenovic', N'PM Lucas', N'123', N'nikolamladenovic88@gmail.com', N'SRB')
INSERT [dbo].[Ucesnik] ([ID_Ucesnika], [Ime], [Prezime], [Institucija], [Telefon], [eMail], [Oznaka_Drzave]) VALUES (2, N'Christophe', N'Jurczak', N'Lucibel, QC Ware in Palo Alto, CA', NULL, NULL, N'USA')
INSERT [dbo].[Ucesnik] ([ID_Ucesnika], [Ime], [Prezime], [Institucija], [Telefon], [eMail], [Oznaka_Drzave]) VALUES (6, N'Josephine', N'Marquele', N'PM Lucas', N'1234', N'josephinemarq23@gmail.com', N'USA')
INSERT [dbo].[Ucesnik] ([ID_Ucesnika], [Ime], [Prezime], [Institucija], [Telefon], [eMail], [Oznaka_Drzave]) VALUES (11, N'Novi', N'Ucesnika', N'ITS', NULL, N'asfwer97@gmail.com', N'CRO')
SET IDENTITY_INSERT [dbo].[Ucesnik] OFF
GO
ALTER TABLE [dbo].[Autor_Rada]  WITH CHECK ADD  CONSTRAINT [FK__Autor_Rad__BrRad__3B75D760] FOREIGN KEY([BrRada])
REFERENCES [dbo].[Rad] ([BrRada])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Autor_Rada] CHECK CONSTRAINT [FK__Autor_Rad__BrRad__3B75D760]
GO
ALTER TABLE [dbo].[Autor_Rada]  WITH CHECK ADD  CONSTRAINT [FK__Autor_Rad__ID_Uc__3C69FB99] FOREIGN KEY([ID_Ucesnika])
REFERENCES [dbo].[Ucesnik] ([ID_Ucesnika])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Autor_Rada] CHECK CONSTRAINT [FK__Autor_Rad__ID_Uc__3C69FB99]
GO
ALTER TABLE [dbo].[Grad]  WITH CHECK ADD FOREIGN KEY([Oznaka_Drzave])
REFERENCES [dbo].[Drzava] ([Oznaka])
GO
ALTER TABLE [dbo].[Izlaganje]  WITH CHECK ADD FOREIGN KEY([BrRada], [ID_Ucesnika])
REFERENCES [dbo].[Autor_Rada] ([BrRada], [ID_Ucesnika])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Izlaganje]  WITH CHECK ADD  CONSTRAINT [FK__Izlaganje__ID_Sa__403A8C7D] FOREIGN KEY([ID_Sale])
REFERENCES [dbo].[Sala] ([ID_Sale])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Izlaganje] CHECK CONSTRAINT [FK__Izlaganje__ID_Sa__403A8C7D]
GO
ALTER TABLE [dbo].[Konferencija]  WITH CHECK ADD FOREIGN KEY([ID_Organizatora])
REFERENCES [dbo].[Organizator] ([ID_Organizatora])
GO
ALTER TABLE [dbo].[Konferencija]  WITH CHECK ADD FOREIGN KEY([ID_Organizatora])
REFERENCES [dbo].[Organizator] ([ID_Organizatora])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Odrzava_Se]  WITH CHECK ADD FOREIGN KEY([ID_Broj])
REFERENCES [dbo].[Konferencija] ([ID_Broj])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Odrzava_Se]  WITH CHECK ADD  CONSTRAINT [FK__Odrzava_S__ID_Sa__38996AB5] FOREIGN KEY([ID_Sale])
REFERENCES [dbo].[Sala] ([ID_Sale])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Odrzava_Se] CHECK CONSTRAINT [FK__Odrzava_S__ID_Sa__38996AB5]
GO
ALTER TABLE [dbo].[Organizator]  WITH CHECK ADD FOREIGN KEY([ID_Grada])
REFERENCES [dbo].[Grad] ([PTT])
GO
ALTER TABLE [dbo].[Sala]  WITH CHECK ADD  CONSTRAINT [FK__Sala__ID_Grada__31EC6D26] FOREIGN KEY([ID_Grada])
REFERENCES [dbo].[Grad] ([PTT])
GO
ALTER TABLE [dbo].[Sala] CHECK CONSTRAINT [FK__Sala__ID_Grada__31EC6D26]
GO
ALTER TABLE [dbo].[Ucesnik]  WITH CHECK ADD  CONSTRAINT [FK__Ucesnik__Oznaka___286302EC] FOREIGN KEY([Oznaka_Drzave])
REFERENCES [dbo].[Drzava] ([Oznaka])
GO
ALTER TABLE [dbo].[Ucesnik] CHECK CONSTRAINT [FK__Ucesnik__Oznaka___286302EC]
GO
ALTER TABLE [dbo].[Izlaganje]  WITH CHECK ADD  CONSTRAINT [TS] CHECK  (([TipSesije]='Radionice' OR [TipSesije]='Stucna' OR [TipSesije]='Poster' OR [TipSesije]='Redovna' OR [TipSesije]='Uvodna' OR [TipSesije]='Pozivna'))
GO
ALTER TABLE [dbo].[Izlaganje] CHECK CONSTRAINT [TS]
GO
ALTER TABLE [dbo].[Sala]  WITH CHECK ADD  CONSTRAINT [OZ] CHECK  (([Ozvucena]='NE' OR [Ozvucena]='DA'))
GO
ALTER TABLE [dbo].[Sala] CHECK CONSTRAINT [OZ]
GO
/****** Object:  StoredProcedure [dbo].[Info_konferencija]    Script Date: 4/21/2021 3:47:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Info_konferencija]
@NazivKonf varchar(80),
@DatumOdrzavanja Date = NULL 
AS
BEGIN
IF @DatumOdrzavanja IS NULL
SELECT Konferencija.Naziv, Konferencija.DatPocetka, Konferencija.DatZavrsetka, Organizator.Naziv AS 'Organizator',
Organizator.Adresa_sedista, Drzava.Naziv AS "Drzava u kojoj se odrzava", Grad.Naziv AS Grad, Sala.Naziv AS Nazivi_Sala,
Sala.Adresa, Sala.Kapacitet, Sala.Ozvucena
FROM ((Konferencija join Organizator on Konferencija.ID_Organizatora=Organizator.ID_Organizatora)
LEFT JOIN Odrzava_Se ON Konferencija.ID_Broj=Odrzava_Se.ID_Broj)
LEFT JOIN SALA ON Odrzava_Se.ID_Sale=Sala.ID_Sale LEFT JOIN Grad ON
Sala.ID_Grada = Grad.PTT
LEFT JOIN Drzava ON Grad.Oznaka_Drzave= Drzava.Oznaka
WHERE Konferencija.Naziv LIKE (SUBSTRING(@NazivKonf, 1, 5)+'%')
ORDER BY Konferencija.Naziv
ELSE
SELECT Konferencija.Naziv, Konferencija.DatPocetka, Konferencija.DatZavrsetka, Organizator.Naziv AS 'Organizator',
Organizator.Adresa_sedista, Drzava.Naziv AS "Drzava u kojoj se odrzava", Grad.Naziv AS Grad, Sala.Naziv AS Nazivi_Sala, Sala.Adresa, Sala.Kapacitet, Sala.Ozvucena
FROM ((Konferencija join Organizator on Konferencija.ID_Organizatora=Organizator.ID_Organizatora)
LEFT JOIN Odrzava_Se ON Konferencija.ID_Broj=Odrzava_Se.ID_Broj)
LEFT JOIN SALA ON Odrzava_Se.ID_Sale=Sala.ID_Sale LEFT JOIN Grad ON Sala.ID_Grada = Grad.PTT
LEFT JOIN Drzava ON Grad.Oznaka_Drzave= Drzava.Oznaka
WHERE Konferencija.Naziv LIKE (SUBSTRING(@NazivKonf,1,5)+ '%') AND
( Konferencija.DatPocetka <= @DatumOdrzavanja AND
Konferencija.DatZavrsetka >= @DatumOdrzavanja)
ORDER BY Konferencija.Naziv
END;
GO
/****** Object:  StoredProcedure [dbo].[PromenaSatniceIzlaganja]    Script Date: 4/21/2021 3:47:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PromenaSatniceIzlaganja]
@broj int = 3, 
@brojSale int = 100,
@Dana date = '2019-03-10',
@minuta int = 7
AS
BEGIN TRY
SET XACT_ABORT ON
BEGIN TRANSACTION;
Declare @vreme datetime;
IF @minuta < 60
SET @vreme = convert(datetime, '00:'+CONVERT(varchar, @minuta)+':00');
ELSE
SET @vreme = convert(datetime, (CONVERT(varchar, @minuta/60)) + ':'+ CONVERT(varchar,(@minuta%60)) + ':00');
UPDATE AA 
SET AA.StaroVreme = AA.DatumVreme, AA.DatumVreme = AA.DatumVreme - convert(datetime, @vreme)
FROM (SELECT TOP(@broj) ID_Ucesnika, BrRada, ID_Sale, DatumVreme, StaroVreme
FROM Izlaganje
WHERE ID_Sale = @brojSale AND CONVERT(date,DatumVreme) = CONVERT(date,@Dana)
ORDER BY DatumVreme) AS AA
WHERE AA.ID_Ucesnika NOT IN
(SELECT V.UcesnikID
FROM (SELECT CC.ID_Ucesnika As UcesnikID, COUNT(CC.ID_Ucesnika) AS PrezentujeBr
FROM Izlaganje AS CC
WHERE CONVERT(date,CC.DatumVreme) = CONVERT(date,@Dana)
GROUP BY CC.ID_Ucesnika ) AS V
WHERE V.PrezentujeBr > 1 )
SELECT TOP(@broj + 2) I.ID_Ucesnika, U.Ime + u.Prezime AS Ime_Prezime_Autora, I.BrRada, RR.Naziv, I.ID_Sale,
SL.Naziv, I.DatumVreme, I.StaroVreme
FROM (Izlaganje AS I JOIN Autor_Rada AS AR ON I.ID_Ucesnika = AR.ID_Ucesnika AND I.BrRada = AR.BrRada
LEFT JOIN Ucesnik AS U ON AR.ID_Ucesnika=U.ID_Ucesnika) LEFT JOIN Rad AS RR ON AR.BrRada= RR.BrRada
LEFT JOIN Sala AS SL ON I.ID_Sale = SL.ID_Sale
WHERE I.ID_Sale=@brojSale AND CONVERT(date,I.DatumVreme) = CONVERT(date,@Dana)
ORDER BY I.DatumVreme
--
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
PRINT 'DOŠLO JE DO POJAVE GREŠKE!'
PRINT 'Transakcija je Vratila pređašnje stanje'
PRINT '------ Proverite ulazne parametre-------'
SELECT 'Problem sa ulaznim paramertima! >' AS Naziv,
@broj AS 'Odabrani broj', @brojSale AS 'Broj Sale', @Dana AS 'Dana', @minuta AS 'Pomeranje za Minuta';
ROLLBACK TRANSACTION;
END CATCH;
GO
