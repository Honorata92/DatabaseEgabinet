USE [master]
GO
/****** Object:  Database [Egabinet2]    Script Date: 03.02.2022 20:58:43 ******/
CREATE DATABASE [Egabinet2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Egabinet2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Egabinet2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Egabinet2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Egabinet2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Egabinet2] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Egabinet2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Egabinet2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Egabinet2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Egabinet2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Egabinet2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Egabinet2] SET ARITHABORT OFF 
GO
ALTER DATABASE [Egabinet2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Egabinet2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Egabinet2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Egabinet2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Egabinet2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Egabinet2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Egabinet2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Egabinet2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Egabinet2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Egabinet2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Egabinet2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Egabinet2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Egabinet2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Egabinet2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Egabinet2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Egabinet2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Egabinet2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Egabinet2] SET RECOVERY FULL 
GO
ALTER DATABASE [Egabinet2] SET  MULTI_USER 
GO
ALTER DATABASE [Egabinet2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Egabinet2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Egabinet2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Egabinet2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Egabinet2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Egabinet2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Egabinet2', N'ON'
GO
ALTER DATABASE [Egabinet2] SET QUERY_STORE = OFF
GO
USE [Egabinet2]
GO
/****** Object:  UserDefinedFunction [dbo].[IlośćWizyt]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IlośćWizyt]
	(@miesiac INT)
RETURNS int 
AS
Begin

DECLARE @Ilość int
	SET @Ilość =(

	select count (Id) from Wizyty
	where month (TerminWizyty) = @miesiac
	)

	return @Ilość
	End
GO
/****** Object:  UserDefinedFunction [dbo].[JakiKoszt]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE FUNCTION [dbo].[JakiKoszt]
	(@PacjentID INT)
RETURNS money 
AS
BEGIN
			
	DECLARE @Koszt money
	SET @Koszt =	(
					select SUM (Koszt) as 'Kwota wydana w placówce' from Wizyty
					inner join Pacjenci
					on Wizyty.PacjentId = Pacjenci.Id
					inner join Płatności
					on Wizyty.Id = Płatności.WizytaId
					where Pacjenci.Id = @PacjentID
					group by Pacjenci.Id
					
				)
	RETURN @Koszt
END
GO
/****** Object:  UserDefinedFunction [dbo].[ŁącznyWpływ]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ŁącznyWpływ]
	(@miesiac INT)
RETURNS money 
AS
Begin

DECLARE @Koszt money
	SET @Koszt =(

	select sum (koszt) from Wizyty
	inner join Płatności
	on Wizyty.Id = Płatności.WizytaId
	inner join Pacjenci
	on Wizyty.PacjentId = Pacjenci.Id

	where month (TerminWizyty) = @miesiac
	)

	return @Koszt
	End
GO
/****** Object:  Table [dbo].[Pensje]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pensje](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Kwota] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Adresy]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Adresy](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Ulica] [varchar](250) NOT NULL,
	[Miasto] [varchar](250) NOT NULL,
	[KodPocztowy] [varchar](250) NOT NULL,
	[NumerDomu] [varchar](250) NOT NULL,
	[NumerMieszkania] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lekarze]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lekarze](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Imię] [varchar](250) NOT NULL,
	[Nazwisko] [varchar](250) NOT NULL,
	[Telefon] [varchar](250) NOT NULL,
	[SpecjalizacjaId] [int] NOT NULL,
	[AdresId] [int] NOT NULL,
	[NumerUprawnien] [int] NOT NULL,
	[PensjaId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_LekrzeZKrakowa]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_LekrzeZKrakowa]
AS
SELECT Lekarze.Id as IDLekarza, Imię, Nazwisko, SpecjalizacjaId, PensjaId, Ulica, Miasto, KodPocztowy, Kwota
FROM Lekarze
INNER JOIN ADRESY 
ON Lekarze.AdresId = Adresy.Id
INNER JOIN Pensje
on Lekarze.PensjaId=Pensje.Id
GO
/****** Object:  Table [dbo].[Specjalizacje]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Specjalizacje](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nazwa] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_Lekarze]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_Lekarze]
AS
Select Imię + Nazwisko as 'Imię i Nazwisko', SpecjalizacjaId, Nazwa, Kwota as Pensja, Miasto From Lekarze 
inner join Specjalizacje
on Lekarze.SpecjalizacjaId = Specjalizacje.Id
inner join Pensje
on Lekarze.PensjaId=Pensje.Id
left join Adresy
on Lekarze.AdresId = Adresy.Id
GO
/****** Object:  Table [dbo].[Pacjenci]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pacjenci](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Imię] [varchar](250) NOT NULL,
	[Nazwisko] [varchar](250) NOT NULL,
	[Telefon] [varchar](250) NOT NULL,
	[AdresId] [int] NOT NULL,
	[NumerIdentyfikacyjny] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_Pacjenci]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_Pacjenci]
AS
select Imię +  Nazwisko as 'Imię i Nazwisko', NumerIdentyfikacyjny, Ulica, Miasto, KodPocztowy, NumerDomu, NumerMieszkania
from Pacjenci
inner join Adresy
on Pacjenci.AdresId= Adresy.Id
GO
/****** Object:  Table [dbo].[Pielęgniarki]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pielęgniarki](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Imię] [varchar](250) NOT NULL,
	[Nazwisko] [varchar](250) NOT NULL,
	[Telefon] [varchar](250) NOT NULL,
	[AdresId] [int] NOT NULL,
	[NumerIdentyfikacyjny] [varchar](250) NOT NULL,
	[PensjaId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_Pielęgniarki]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_Pielęgniarki]
AS
select Imię  + Nazwisko as 'Imię i nazwisko', Telefon, Ulica, Miasto, KodPocztowy, NumerDomu, NumerMieszkania, 
Kwota as Wynagrodzenie
from Pielęgniarki
inner join Adresy
on Pielęgniarki.AdresId = Adresy.Id
inner join Pensje
on Pielęgniarki.PensjaId = Pensje.Id
GO
/****** Object:  Table [dbo].[Wizyty]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wizyty](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PacjentId] [int] NOT NULL,
	[LekarzId] [int] NOT NULL,
	[PielęgniarkaId] [int] NULL,
	[PokójIdint] [int] NOT NULL,
	[TerminWizyty] [datetime] NOT NULL,
	[CzasWizyty] [int] NOT NULL,
	[PotwierdzenieWizyty] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[IluPacjentów]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IluPacjentów]
	(@LekarzId INT)
RETURNS TABLE 
AS
RETURN
select Lekarze.Imię + Lekarze.Nazwisko as ' Imię i Nazwisko Lekarza', 
TerminWizyty, Pacjenci.Imię + Pacjenci.Nazwisko as 'Imię i nazwisko Pacjenta ', CzasWizyty
from Wizyty
inner join Pacjenci
on Wizyty.PacjentId =  Pacjenci.Id
inner join Lekarze
on Wizyty.LekarzId= Lekarze.Id
where Lekarze.Id = @LekarzId 
GO
/****** Object:  Table [dbo].[Pokoje]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pokoje](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NumerSali] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[SumaWizytPerPokój]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SumaWizytPerPokój]
()
RETURNS TABLE 
AS
RETURN 
	select Pokoje.Id, count(Wizyty.Id) as 'Ilość wizyt' from Pokoje
	inner join Wizyty 
	on Pokoje.Id = Wizyty.PokójIdint
	group by Pokoje.Id
GO
/****** Object:  Table [dbo].[KartyPacjentów]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KartyPacjentów](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PacjentId] [int] NULL,
	[Szczegóły] [varchar](250) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Płatności]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Płatności](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WizytaId] [int] NULL,
	[FormaPlatnosci] [varchar](250) NOT NULL,
	[Koszt] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recepty]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recepty](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Data] [datetime] NOT NULL,
	[Opis] [varchar](250) NOT NULL,
	[NumerRecepty] [int] NOT NULL,
	[LekarzId] [int] NOT NULL,
	[PacjentId] [int] NOT NULL,
	[KartaPacjentaId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Adresy] ON 

INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (1, N'Dębowa', N'Kryspinów', N'32-060', N'1', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (2, N'Brzoskwiniowa', N'Mogilany', N'32-031', N'1', N'5')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (3, N'Leśna', N'Kraków', N'30-499', N'4', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (4, N'Aroniowa', N'Myślenice', N'32-400', N'5', N'25')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (5, N'Bobrzyńskiego', N'Kraków', N'30-348', N'5', N'1')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (6, N'Adama Mickiewicza', N'Kraków', N'30-348', N'74', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (7, N'Czerwona', N'Kraków', N'30-499', N'475', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (8, N'Czarna', N'Kryspinów', N'32-060', N'745', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (9, N'Sopocka', N'Kraków', N'30-348', N'784', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (10, N'Różana', N'Kryspinów', N'32-060', N'757', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (11, N'Zielona', N'Mogilany', N'32-031', N'758', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (12, N'Zielona', N'Mogilany', N'32-031', N'475', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (13, N'Grzegórzecka', N'Kraków', N'30-348', N'74', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (14, N'Basztowa', N'Kryspinów', N'32-060', N'1', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (15, N'Okopowa', N'Kraków', N'30-458', N'125', N'58')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (16, N'Irysowa', N'Czernichów', N'32-060', N'147', N'57')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (17, N'Czarna', N'Sopot', N'25-874', N'25', N'10')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (18, N'Zielona', N'Warszawa', N'25-500', N'48', N'4')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (19, N'Czarna', N'Sopot', N'25-874', N'4', N'10')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (20, N'Zielona', N'Warszawa', N'25-500', N'48', N'41')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (21, N'Alabastrowa', N'Sopot', N'25-874', N'25', N'10')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (22, N'Bobrzyńskiego', N'Warszawa', N'25-500', N'48', N'4')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (23, N'Wicherkiewicza', N'Sopot', N'25-874', N'25', N'10')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (24, N'Gaj', N'Warszawa', N'25-500', N'48', N'4')
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (25, N'Mostowa', N'Kryspinów', N'32-060', N'458', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (26, N'Kryspiniów', N'Kryspinów', N'32-060', N'128', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (27, N'Kryspiniów', N'Kryspinów', N'32-060', N'108', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (28, N'Kryspiniów', N'Kryspinów', N'32-060', N'12', NULL)
INSERT [dbo].[Adresy] ([Id], [Ulica], [Miasto], [KodPocztowy], [NumerDomu], [NumerMieszkania]) VALUES (29, N'Kryspiniów', N'Kryspinów', N'32-060', N'187', NULL)
SET IDENTITY_INSERT [dbo].[Adresy] OFF
GO
SET IDENTITY_INSERT [dbo].[KartyPacjentów] ON 

INSERT [dbo].[KartyPacjentów] ([Id], [PacjentId], [Szczegóły]) VALUES (1, 1, N'Rozpoznanie COVID')
INSERT [dbo].[KartyPacjentów] ([Id], [PacjentId], [Szczegóły]) VALUES (2, 2, N'Rozpoznanie COVID')
INSERT [dbo].[KartyPacjentów] ([Id], [PacjentId], [Szczegóły]) VALUES (3, 3, N'Astma Oskrzelowa')
INSERT [dbo].[KartyPacjentów] ([Id], [PacjentId], [Szczegóły]) VALUES (4, 4, N'Rozpoznanie COVID')
SET IDENTITY_INSERT [dbo].[KartyPacjentów] OFF
GO
SET IDENTITY_INSERT [dbo].[Lekarze] ON 

INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (1, N'Zofia', N'Kowalska', N'625748695', 1, 1, 1478564, 1)
INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (2, N'Izabela', N'Nowak', N'725798695', 1, 5, 5471235, 1)
INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (3, N'Adam', N'Wesołowska', N'825791691', 2, 6, 5478962, 2)
INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (4, N'Marek', N'Adam', N'555491691', 3, 2, 4132587, 2)
INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (5, N'Edward', N'Krzysztofik', N'551491791', 6, 4, 4789632, 7)
INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (6, N'Anna', N'Augustyńska', N'751401741', 5, 3, 5478523, 4)
INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (7, N'Stanisław', N'Kowalik', N'5014017791', 1, 7, 1743574, 5)
INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (8, N'Zygmunt', N'Osma', N'551001791', 4, 10, 4475221, 5)
INSERT [dbo].[Lekarze] ([Id], [Imię], [Nazwisko], [Telefon], [SpecjalizacjaId], [AdresId], [NumerUprawnien], [PensjaId]) VALUES (9, N'Helena', N'Zagórowska', N'57771001791', 8, 11, 4478523, 6)
SET IDENTITY_INSERT [dbo].[Lekarze] OFF
GO
SET IDENTITY_INSERT [dbo].[Pacjenci] ON 

INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (1, N'Elżbieta', N'Nowak', N'625741954', 13, N'74859674121')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (2, N'Iryna', N'Samsonowa', N'720098695', 14, N'ZI54S22Z1')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (3, N'Edward', N'Kowalik', N'820011221', 15, N'87452247114')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (4, N'Krystyna', N'Kowalik', N'658011221', 15, N'81457447014')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (5, N'Aleksandra', N'Nowak', N'625741954', 13, N'17182247125')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (6, N'Jakub', N'Nowak', N'625741954', 13, N'18180240025')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (7, N'Andrzej', N'Kowalczyk', N'547965852', 17, N'74569874112')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (8, N'Zofia', N'Zasada', N'547963214', 18, N'58965411022')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (9, N'Euzebiusz', N'Kowalczyk', N'547965852', 19, N'74569004112')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (10, N'Zofia', N'Miszczyk', N'547963214', 20, N'58965411022')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (11, N'Andrzej', N'Len', N'547005852', 21, N'70069800112')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (12, N'Aniela', N'Zasada', N'500163014', 22, N'58060711022')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (13, N'Zdziław', N'Mech', N'700853321', 23, N'74500874112')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (14, N'Janina', N'Bez', N'500963200', 24, N'5006541102')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (15, N'Janina', N'Nowak', N'620041954', 25, N'56859674121')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (16, N'Jan', N'Kowalik', N'620041954', 27, N'82851174121')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (17, N'Marek', N'Ostafik', N'700041004', 28, N'97850074121')
INSERT [dbo].[Pacjenci] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny]) VALUES (18, N'Stanisława', N'Nowik', N'500041154', 29, N'85852274121')
SET IDENTITY_INSERT [dbo].[Pacjenci] OFF
GO
SET IDENTITY_INSERT [dbo].[Pensje] ON 

INSERT [dbo].[Pensje] ([Id], [Kwota]) VALUES (1, 3800.0000)
INSERT [dbo].[Pensje] ([Id], [Kwota]) VALUES (2, 3500.0000)
INSERT [dbo].[Pensje] ([Id], [Kwota]) VALUES (3, 5600.0000)
INSERT [dbo].[Pensje] ([Id], [Kwota]) VALUES (4, 5700.0000)
INSERT [dbo].[Pensje] ([Id], [Kwota]) VALUES (5, 8700.0000)
INSERT [dbo].[Pensje] ([Id], [Kwota]) VALUES (6, 5400.0000)
INSERT [dbo].[Pensje] ([Id], [Kwota]) VALUES (7, 6500.0000)
INSERT [dbo].[Pensje] ([Id], [Kwota]) VALUES (8, 4100.0000)
SET IDENTITY_INSERT [dbo].[Pensje] OFF
GO
SET IDENTITY_INSERT [dbo].[Pielęgniarki] ON 

INSERT [dbo].[Pielęgniarki] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny], [PensjaId]) VALUES (1, N'Zofia', N'Adamska', N'625741954', 8, N'7485967412', 1)
INSERT [dbo].[Pielęgniarki] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny], [PensjaId]) VALUES (2, N'Iryna', N'Samsonowa', N'720098695', 9, N'CX54S54Z1', 1)
INSERT [dbo].[Pielęgniarki] ([Id], [Imię], [Nazwisko], [Telefon], [AdresId], [NumerIdentyfikacyjny], [PensjaId]) VALUES (3, N'Vadim', N'Igorsy', N'821741001', 12, N'CO874DE22', 1)
SET IDENTITY_INSERT [dbo].[Pielęgniarki] OFF
GO
SET IDENTITY_INSERT [dbo].[Płatności] ON 

INSERT [dbo].[Płatności] ([Id], [WizytaId], [FormaPlatnosci], [Koszt]) VALUES (1, 1, N'karta', 150.0000)
INSERT [dbo].[Płatności] ([Id], [WizytaId], [FormaPlatnosci], [Koszt]) VALUES (2, 2, N'NFZ', 0.0000)
INSERT [dbo].[Płatności] ([Id], [WizytaId], [FormaPlatnosci], [Koszt]) VALUES (3, 3, N'gotówka', 150.0000)
INSERT [dbo].[Płatności] ([Id], [WizytaId], [FormaPlatnosci], [Koszt]) VALUES (4, 4, N'gotówka', 150.0000)
SET IDENTITY_INSERT [dbo].[Płatności] OFF
GO
SET IDENTITY_INSERT [dbo].[Pokoje] ON 

INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (1, N'4')
INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (2, N'4A')
INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (3, N'5C')
INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (4, N'6')
INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (5, N'6A')
INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (6, N'6B')
INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (7, N'7A')
INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (8, N'8')
INSERT [dbo].[Pokoje] ([Id], [NumerSali]) VALUES (9, N'8B')
SET IDENTITY_INSERT [dbo].[Pokoje] OFF
GO
SET IDENTITY_INSERT [dbo].[Recepty] ON 

INSERT [dbo].[Recepty] ([Id], [Data], [Opis], [NumerRecepty], [LekarzId], [PacjentId], [KartaPacjentaId]) VALUES (1, CAST(N'2021-01-11T17:00:00.000' AS DateTime), N'Tabletki', 1, 1, 1, 1)
INSERT [dbo].[Recepty] ([Id], [Data], [Opis], [NumerRecepty], [LekarzId], [PacjentId], [KartaPacjentaId]) VALUES (2, CAST(N'2021-10-05T12:00:00.000' AS DateTime), N'Tabletki', 2, 1, 2, 2)
INSERT [dbo].[Recepty] ([Id], [Data], [Opis], [NumerRecepty], [LekarzId], [PacjentId], [KartaPacjentaId]) VALUES (3, CAST(N'2022-02-01T10:15:00.000' AS DateTime), N'Sterydy', 3, 7, 3, 3)
INSERT [dbo].[Recepty] ([Id], [Data], [Opis], [NumerRecepty], [LekarzId], [PacjentId], [KartaPacjentaId]) VALUES (4, CAST(N'2020-02-06T09:05:00.000' AS DateTime), N'Tabletki', 4, 1, 4, 4)
SET IDENTITY_INSERT [dbo].[Recepty] OFF
GO
SET IDENTITY_INSERT [dbo].[Specjalizacje] ON 

INSERT [dbo].[Specjalizacje] ([Id], [Nazwa]) VALUES (1, N'Rodzinny')
INSERT [dbo].[Specjalizacje] ([Id], [Nazwa]) VALUES (2, N'Pediatra')
INSERT [dbo].[Specjalizacje] ([Id], [Nazwa]) VALUES (3, N'Endokrynolog')
INSERT [dbo].[Specjalizacje] ([Id], [Nazwa]) VALUES (4, N'Alergolog')
INSERT [dbo].[Specjalizacje] ([Id], [Nazwa]) VALUES (5, N'Dermatolog')
INSERT [dbo].[Specjalizacje] ([Id], [Nazwa]) VALUES (6, N'Podolog')
INSERT [dbo].[Specjalizacje] ([Id], [Nazwa]) VALUES (7, N'Pulmunolog')
INSERT [dbo].[Specjalizacje] ([Id], [Nazwa]) VALUES (8, N'Laryngolog')
SET IDENTITY_INSERT [dbo].[Specjalizacje] OFF
GO
SET IDENTITY_INSERT [dbo].[Wizyty] ON 

INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (1, 1, 1, 1, 1, CAST(N'2021-01-11T17:00:00.000' AS DateTime), 10, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (2, 2, 1, 1, 1, CAST(N'2021-10-05T12:00:00.000' AS DateTime), 20, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (3, 3, 7, 1, 2, CAST(N'2022-02-01T10:15:00.000' AS DateTime), 20, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (4, 4, 1, 1, 2, CAST(N'2020-02-06T09:05:00.000' AS DateTime), 20, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (5, 5, 5, 2, 7, CAST(N'2021-05-20T15:15:00.000' AS DateTime), 25, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (7, 2, 4, 3, 8, CAST(N'2022-05-20T15:15:00.000' AS DateTime), 25, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (8, 15, 1, 1, 1, CAST(N'2021-01-05T12:00:00.000' AS DateTime), 15, 0)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (9, 16, 2, 2, 2, CAST(N'2021-01-05T15:15:00.000' AS DateTime), 15, 0)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (10, 3, 4, 2, 3, CAST(N'2021-01-07T14:20:00.000' AS DateTime), 15, 0)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (11, 10, 1, 3, 4, CAST(N'2021-01-20T18:20:00.000' AS DateTime), 15, 0)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (12, 10, 3, 2, 5, CAST(N'2021-01-20T17:20:00.000' AS DateTime), 15, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (13, 11, 5, 1, 2, CAST(N'2021-01-20T17:20:00.000' AS DateTime), 15, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (14, 8, 4, 2, 1, CAST(N'2021-01-20T17:20:00.000' AS DateTime), 15, 1)
INSERT [dbo].[Wizyty] ([Id], [PacjentId], [LekarzId], [PielęgniarkaId], [PokójIdint], [TerminWizyty], [CzasWizyty], [PotwierdzenieWizyty]) VALUES (15, 4, 1, 2, 6, CAST(N'2021-01-20T17:20:00.000' AS DateTime), 15, 1)
SET IDENTITY_INSERT [dbo].[Wizyty] OFF
GO
/****** Object:  Index [UQ__Lekarze__97FD82CECBE7E038]    Script Date: 03.02.2022 20:58:43 ******/
ALTER TABLE [dbo].[Lekarze] ADD UNIQUE NONCLUSTERED 
(
	[NumerUprawnien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Pielęgni__1C80B66DD9776662]    Script Date: 03.02.2022 20:58:43 ******/
ALTER TABLE [dbo].[Pielęgniarki] ADD UNIQUE NONCLUSTERED 
(
	[NumerIdentyfikacyjny] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[KartyPacjentów]  WITH CHECK ADD FOREIGN KEY([PacjentId])
REFERENCES [dbo].[Pacjenci] ([Id])
GO
ALTER TABLE [dbo].[Lekarze]  WITH CHECK ADD FOREIGN KEY([AdresId])
REFERENCES [dbo].[Adresy] ([Id])
GO
ALTER TABLE [dbo].[Lekarze]  WITH CHECK ADD FOREIGN KEY([PensjaId])
REFERENCES [dbo].[Pensje] ([Id])
GO
ALTER TABLE [dbo].[Lekarze]  WITH CHECK ADD FOREIGN KEY([SpecjalizacjaId])
REFERENCES [dbo].[Specjalizacje] ([Id])
GO
ALTER TABLE [dbo].[Pacjenci]  WITH CHECK ADD FOREIGN KEY([AdresId])
REFERENCES [dbo].[Adresy] ([Id])
GO
ALTER TABLE [dbo].[Pielęgniarki]  WITH CHECK ADD FOREIGN KEY([AdresId])
REFERENCES [dbo].[Adresy] ([Id])
GO
ALTER TABLE [dbo].[Pielęgniarki]  WITH CHECK ADD FOREIGN KEY([PensjaId])
REFERENCES [dbo].[Pensje] ([Id])
GO
ALTER TABLE [dbo].[Płatności]  WITH CHECK ADD FOREIGN KEY([WizytaId])
REFERENCES [dbo].[Wizyty] ([Id])
GO
ALTER TABLE [dbo].[Recepty]  WITH CHECK ADD FOREIGN KEY([KartaPacjentaId])
REFERENCES [dbo].[Pacjenci] ([Id])
GO
ALTER TABLE [dbo].[Recepty]  WITH CHECK ADD FOREIGN KEY([LekarzId])
REFERENCES [dbo].[Lekarze] ([Id])
GO
ALTER TABLE [dbo].[Recepty]  WITH CHECK ADD FOREIGN KEY([PacjentId])
REFERENCES [dbo].[Pacjenci] ([Id])
GO
ALTER TABLE [dbo].[Wizyty]  WITH CHECK ADD FOREIGN KEY([LekarzId])
REFERENCES [dbo].[Lekarze] ([Id])
GO
ALTER TABLE [dbo].[Wizyty]  WITH CHECK ADD FOREIGN KEY([PacjentId])
REFERENCES [dbo].[Pacjenci] ([Id])
GO
ALTER TABLE [dbo].[Wizyty]  WITH CHECK ADD FOREIGN KEY([PielęgniarkaId])
REFERENCES [dbo].[Pielęgniarki] ([Id])
GO
ALTER TABLE [dbo].[Wizyty]  WITH CHECK ADD FOREIGN KEY([PokójIdint])
REFERENCES [dbo].[Pokoje] ([Id])
GO
/****** Object:  StoredProcedure [dbo].[DodajPacjenta]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DodajPacjenta]
	@Ulica varchar (255),
	@Miasto varchar (255),
	@KodPocztowy varchar(255),
	@NumerDomu varchar(255),
	@NumerMieszkania varchar(255),
	@Imię varchar(255),
	@Nazwisko varchar(255),
	@Telefon varchar(255),
	@NumerIdentyfikacyjny varchar(255)

AS
BEGIN
	INSERT Adresy	
	VALUES (@Ulica,@Miasto, @KodPocztowy,@NumerDomu,@NumerMieszkania)
	declare @LastId int
	Set @LastId=@@IDENTITY

	INSERT Pacjenci
	VALUES ( @Imię, @Nazwisko,@Telefon, @LastId, @NumerIdentyfikacyjny)
END
GO
/****** Object:  StoredProcedure [dbo].[DodajWizyte]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[DodajWizyte]
	@PacjentID int,
	@LekarzID int,
	@PielęgniarkaID int,
	@PokójID int,
	@TerminWizyty datetime,
	@CzasWizyty int,
	@PotwierdzenieWizyty bit
AS BEGIN
INSERT Wizyty
Values (@PacjentID, @LekarzID, @PielęgniarkaID, @PokójID, @TerminWizyty, @CzasWizyty, @PotwierdzenieWizyty)
END
GO
/****** Object:  StoredProcedure [dbo].[IlośćPacjentówLekarza]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[IlośćPacjentówLekarza]
	@LekarzID int,
	@Liczba int OUTPUT
AS BEGIN
SET @Liczba = (SELECT COUNT(DISTINCT Pacjenci.id)
					FROM Lekarze
					inner join Wizyty
					on Lekarze.id = Wizyty.LekarzId
					inner join Pacjenci
					on Wizyty.PacjentId = Pacjenci.Id
					WHERE Lekarze.id = @LekarzID)
END
GO
/****** Object:  StoredProcedure [dbo].[IlośćWizytPoChorobie]    Script Date: 03.02.2022 20:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[IlośćWizytPoChorobie]
	@Choroba varchar(200),
	@Liczba int OUTPUT
AS BEGIN
SET @Liczba = (SELECT COUNT(*)
					FROM KartyPacjentów
					WHERE Szczegóły like '%' + @Choroba + '%')
END
GO
USE [master]
GO
ALTER DATABASE [Egabinet2] SET  READ_WRITE 
GO
