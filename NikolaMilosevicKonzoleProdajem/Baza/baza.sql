create database konzole

go

use konzole

go

create table lokacija (
	lokacija_id int PRIMARY KEY IDENTITY(1,1),
	ime nvarchar(100)
)
go

create table stanje_konzole (
	stanje_konzole_id int PRIMARY KEY IDENTITY(1,1),
	naziv nvarchar(100)
)
go

create table garancija (
	garancija_id int PRIMARY KEY IDENTITY(1,1),
	naziv nvarchar(100)
)
go

create table valuta (
	valuta_id int PRIMARY KEY IDENTITY(1,1),
	naziv nvarchar(20),
	simbol nvarchar(10),
	kurs_u_eur decimal(10,4)
)
go

create table korisnik (
	korisnik_id int PRIMARY KEY IDENTITY(1,1),
	korisnik_ime nvarchar(20),
	korisnik_email nvarchar(50),
	korisnik_loz nvarchar(100),
	korisnik_lokacija_id int,
	korisnik_telefon nvarchar(20),
	korisnik_racun nvarchar(30),
	korisnik_status nvarchar(20),
	korisnik_poz_ocene int,
	korisnik_neg_ocene int
)
go

create table marka (
	marka_id int primary key identity(1,1),
	naziv nvarchar(50) not null unique
)
go

create table model (
	model_id int primary key identity(1,1),
	marka_id int not null,
	naziv nvarchar(50) not null
)
go

create table konzola (
	konzola_id int primary key identity(1,1),
	marka_id int not null,
	model_id int not null
)
go

create table oglas (
	oglas_id int PRIMARY KEY IDENTITY(1,1),
	konzola_id int,
	korisnik_id int,
	naziv nvarchar(100),
	cena int,
	valuta_id int,
	garancija_id int,
	stanje_id int,
	opis nvarchar(400),
	datum_objave datetime,
	memorijski_prostor nvarchar(10)
)
go

create table slike (
	slika_id int PRIMARY KEY IDENTITY(1,1),
	oglas_id int,
	putanja nvarchar(255)
)
go

create table oglas_audit (
	audit_id int PRIMARY KEY IDENTITY(1,1),
	oglas_id int,
	konzola_id int,
	korisnik_id int,
	cena int,
	valuta_id int,
	garancija_id int,
	stanje_id int,
	opis nvarchar(400),
	datum_objave date,
	memorijski_prostor nvarchar(10),
	akcija nvarchar(10),
	vreme_akcije datetime default getdate()
)
go


alter table model
add constraint FK_ModelMarka
foreign key (marka_id) references marka(marka_id)
go

alter table konzola
add constraint FK_KonzolaMarka
foreign key (marka_id) references marka(marka_id)
go

alter table konzola
add constraint FK_KonzolaModel
foreign key (model_id) references model(model_id)
go

alter table korisnik
add constraint FK_Korisniklokacija
foreign key (korisnik_lokacija_id) references lokacija(lokacija_id)
go

alter table oglas
add constraint FK_Oglaskonzola
foreign key (konzola_id) references konzola(konzola_id)
go

alter table oglas
add constraint FK_Oglaskorisnik
foreign key (korisnik_id) references korisnik(korisnik_id)
go

alter table oglas
add constraint FK_Oglasgarancija
foreign key (garancija_id) references garancija(garancija_id)
go

alter table oglas
add constraint FK_Oglasstanje
foreign key (stanje_id) references stanje_konzole(stanje_konzole_id)
go

alter table oglas
add constraint FK_Oglasvaluta
foreign key (valuta_id) references valuta(valuta_id)
go

alter table slike
add constraint FK_SlikeOglas
foreign key (oglas_id) references oglas(oglas_id)

go

create procedure provera_korisnika
@email nvarchar(50),
@lozinka nvarchar(100)
as
set lock_timeout 3000;
begin try
	if exists(select top 1 korisnik_email from korisnik 
	where korisnik_email=@email and korisnik_loz=@lozinka)
		begin
			return 0
		end
	return 1
end try
begin catch
	return @@error
end catch

go

create procedure uzmi_id_po_emailu
    @email nvarchar(50)
as
begin
    select korisnik_id
    from korisnik
    where korisnik_email = @email
end

go

create procedure unos_korisnika
    @ime nvarchar(20),
    @email nvarchar(50),
    @lozinka nvarchar(100),
    @lokacija_id int,
    @telefon nvarchar(20),
    @racun nvarchar(30),
    @status nvarchar(20)
as
set lock_timeout 3000;
begin try
    if exists (select 1 from korisnik where korisnik_email = @email)
        return 1

    if exists (select 1 from korisnik where korisnik_telefon = @telefon)
        return 2

    insert into korisnik(
        korisnik_ime,
        korisnik_email,
        korisnik_loz,
        korisnik_lokacija_id,
        korisnik_telefon,
        korisnik_racun,
        korisnik_status,
        korisnik_poz_ocene,
        korisnik_neg_ocene
    )
    values(
        @ime,
        @email,
        @lozinka,
        @lokacija_id,
        @telefon,
        @racun,
        @status,
        0,
        0
    )

    return 0
end try
begin catch
	return @@error
end catch

go

create procedure brisanje_korisnika
@email nvarchar(50),
@lozinka nvarchar(100)
as
set lock_timeout 3000;
begin try
	declare @rez int;
	exec @rez = provera_korisnika @email, @lozinka
	if @rez=0
		begin
			delete from korisnik
			where korisnik_email=@email and korisnik_loz=@lozinka
			return 0
		end
	return 1
end try
begin catch
	return @@error
end catch

go

create procedure izmena_lozinke_korisnika
@email nvarchar(50),
@lozinka nvarchar(100),
@nova_lozinka nvarchar(100)
as
set lock_timeout 3000;
begin try
	declare @rez int;
	exec @rez = provera_korisnika @email, @lozinka
	if @rez=0
		begin
			update korisnik
			set korisnik_loz = @nova_lozinka
			where korisnik_email = @email and korisnik_loz = @lozinka
			return 0
		end
	return 1
end try
begin catch
	return @@error
end catch

go

create procedure uzmi_korisnika_detaljno
@korisnik_id int
as
begin
    select 
        k.korisnik_id,
        k.korisnik_ime,
        k.korisnik_email,
        k.korisnik_telefon,
        k.korisnik_racun,
        k.korisnik_status,
        k.korisnik_poz_ocene,
        k.korisnik_neg_ocene,

        l.lokacija_id,
        l.ime as lokacija,

        (select count(*) 
         from oglas o 
         where o.korisnik_id = k.korisnik_id) as broj_oglasa

    from korisnik k
    inner join lokacija l 
        on k.korisnik_lokacija_id = l.lokacija_id
    where k.korisnik_id = @korisnik_id
end

go

create procedure unos_konzola
    @marka_id int,
    @model_id int
as
begin
    if not exists (
        select 1
        from model
        where model_id = @model_id
        and marka_id = @marka_id
    )
        return 1

    insert into konzola(marka_id, model_id)
    values(@marka_id, @model_id)

    return 0
end

go

create procedure brisanje_konzola
@konzola_id int
as
set lock_timeout 3000;
begin try
	if exists(select top 1 konzola_id from konzola
	where konzola_id = @konzola_id)
		begin
			delete from konzola
			where konzola_id = @konzola_id
			return 0
		end
	return 1
end try
begin catch
	return @@error
end catch

go

create procedure unos_oglasa
@konzola_id int,
@korisnik_id int,
@naziv nvarchar(100),
@cena int,
@valuta_id int,
@garancija_id int,
@stanje_id int,
@opis nvarchar(400),
@datum_objave datetime,
@memorijski_prostor nvarchar(10)
as
begin
	insert into oglas(
		konzola_id,
		korisnik_id,
		naziv,
		cena,
		valuta_id,
		garancija_id,
		stanje_id,
		opis,
		datum_objave,
		memorijski_prostor
	)
	values(
		@konzola_id,
		@korisnik_id,
		@naziv,
		@cena,
		@valuta_id,
		@garancija_id,
		@stanje_id,
		@opis,
		@datum_objave,
		@memorijski_prostor
	)
	return 0
end

go

create procedure uzimanje_svih_oglasa_sa_korisnicima
as
begin
	select 
		o.oglas_id,
		o.naziv,
		o.cena,
		o.datum_objave,
		o.opis,

		sk.naziv as stanje,
		g.naziv as garancija,
		v.naziv as valuta,
		v.simbol as valuta_simbol,

		l.ime as korisnik_lokacija,
		k.korisnik_id,
		k.korisnik_ime,
		k.korisnik_email,
		k.korisnik_poz_ocene,
		k.korisnik_neg_ocene,

		(
			select top 1 s.putanja
			from slike s
			where s.oglas_id = o.oglas_id
			order by s.slika_id asc
		) as putanja

	from oglas o
	inner join korisnik k on o.korisnik_id = k.korisnik_id
	inner join lokacija l on k.korisnik_lokacija_id = l.lokacija_id
	inner join garancija g on o.garancija_id = g.garancija_id
	inner join stanje_konzole sk on o.stanje_id = sk.stanje_konzole_id
	inner join valuta v on o.valuta_id = v.valuta_id
end

go

create procedure search
    @tekst nvarchar(100) = null
as
begin
    select 
        o.oglas_id,
        o.naziv,
        o.cena,
        o.datum_objave,
        o.opis,
        sk.naziv as stanje,
        g.naziv as garancija,
        l.ime as korisnik_lokacija,
        k.korisnik_id,
        k.korisnik_ime,
        k.korisnik_email,
        k.korisnik_poz_ocene,
        k.korisnik_neg_ocene,
		v.naziv as valuta,
		v.simbol as valuta_simbol,
        (
            select top 1 s.putanja
            from slike s
            where s.oglas_id = o.oglas_id
            order by s.slika_id asc
        ) as putanja
    from oglas o
    inner join korisnik k on o.korisnik_id = k.korisnik_id
    inner join lokacija l on k.korisnik_lokacija_id = l.lokacija_id
    inner join garancija g on o.garancija_id = g.garancija_id
	inner join valuta v on o.valuta_id = v.valuta_id
    inner join stanje_konzole sk on o.stanje_id = sk.stanje_konzole_id
    where
        @tekst is null
        or o.naziv like '%' + @tekst + '%'
        or o.opis like '%' + @tekst + '%'
end

go

create procedure search_filter_oglasa
    @tekst nvarchar(100) = null,
    @cena_min decimal(18,4) = null,
    @cena_max decimal(18,4) = null,
    @lokacija int = null,
    @garancija int = null,
    @stanje int = null
as
begin
    select 
        o.oglas_id,
        o.naziv,
        o.cena,
        o.datum_objave,
        o.opis,

        sk.naziv as stanje,
        g.naziv as garancija,
        l.ime as korisnik_lokacija,

        k.korisnik_id,
        k.korisnik_ime,
        k.korisnik_email,
        k.korisnik_poz_ocene,
        k.korisnik_neg_ocene,

        v.naziv as valuta,
        v.simbol as valuta_simbol,

        (o.cena * v.kurs_u_eur) as cena_eur,

        (
            select top 1 s.putanja
            from slike s
            where s.oglas_id = o.oglas_id
            order by s.slika_id asc
        ) as putanja

    from oglas o
    inner join korisnik k on o.korisnik_id = k.korisnik_id
    inner join lokacija l on k.korisnik_lokacija_id = l.lokacija_id
    inner join garancija g on o.garancija_id = g.garancija_id
    inner join valuta v on o.valuta_id = v.valuta_id
    inner join stanje_konzole sk on o.stanje_id = sk.stanje_konzole_id

    where
        (@tekst is null 
            or o.naziv like '%' + @tekst + '%' 
            or o.opis like '%' + @tekst + '%')
        and (@cena_min is null or (o.cena * v.kurs_u_eur) >= @cena_min)
        and (@cena_max is null or (o.cena * v.kurs_u_eur) <= @cena_max)

        and (@lokacija is null or k.korisnik_lokacija_id = @lokacija)
        and (@garancija is null or o.garancija_id = @garancija)
        and (@stanje is null or o.stanje_id = @stanje)
end

go

create PROCEDURE filter_oglasa
@cena_min decimal(18,4) = null,
@cena_max decimal(18,4) = null,
@lokacija nvarchar(50) = null,
@garancija nvarchar(20) = null,
@stanje nvarchar(50) = null
AS
BEGIN
    SELECT 
        o.oglas_id,
        o.naziv,
        o.cena,
        o.datum_objave,
        o.opis,

        sk.naziv as stanje,
        g.naziv as garancija,

        l.ime as korisnik_lokacija,
        k.korisnik_id,
        k.korisnik_ime,
        k.korisnik_email,
        k.korisnik_poz_ocene,
        k.korisnik_neg_ocene,

        v.naziv as valuta,
        v.simbol as valuta_simbol,

        (o.cena * v.kurs_u_eur) as cena_eur,

        (
            SELECT TOP 1 s.putanja
            FROM slike s
            WHERE s.oglas_id = o.oglas_id
            ORDER BY s.slika_id ASC
        ) as putanja

    FROM oglas o
    INNER JOIN korisnik k ON o.korisnik_id = k.korisnik_id
    INNER JOIN lokacija l ON k.korisnik_lokacija_id = l.lokacija_id
    INNER JOIN garancija g ON o.garancija_id = g.garancija_id
    INNER JOIN valuta v ON o.valuta_id = v.valuta_id
    INNER JOIN stanje_konzole sk ON o.stanje_id = sk.stanje_konzole_id

    WHERE
        (@cena_min IS NULL OR (o.cena * v.kurs_u_eur) >= @cena_min)
        AND (@cena_max IS NULL OR (o.cena * v.kurs_u_eur) <= @cena_max)
        AND (@lokacija IS NULL OR k.korisnik_lokacija_id = @lokacija)
        AND (@garancija IS NULL OR o.garancija_id = @garancija)
        AND (@stanje IS NULL OR o.stanje_id = @stanje)
END

go

create PROCEDURE uzmi_oglas_detaljno
    @oglas_id int
AS
BEGIN
    SELECT
        o.oglas_id,
        o.naziv,
        o.cena,
        v.naziv as valuta,
        v.simbol,
        o.opis,
        o.datum_objave,
        o.memorijski_prostor,

        kz.konzola_id,
        m.naziv as marka,
        md.naziv as model,

        sk.naziv as stanje,
        g.naziv as garancija,

        k.korisnik_id,
        k.korisnik_ime,
        k.korisnik_email,
        k.korisnik_telefon,
        k.korisnik_racun,
        k.korisnik_status,
        k.korisnik_poz_ocene,
        k.korisnik_neg_ocene,

        l.ime as lokacija,

        (
            SELECT TOP 1 s.putanja
            FROM slike s
            WHERE s.oglas_id = o.oglas_id
            ORDER BY s.slika_id ASC
        ) as putanja

    FROM oglas o
    INNER JOIN konzola kz ON o.konzola_id = kz.konzola_id
    INNER JOIN marka m ON kz.marka_id = m.marka_id
    INNER JOIN model md ON kz.model_id = md.model_id

    INNER JOIN korisnik k ON o.korisnik_id = k.korisnik_id
    INNER JOIN lokacija l ON k.korisnik_lokacija_id = l.lokacija_id
    INNER JOIN garancija g ON o.garancija_id = g.garancija_id
    INNER JOIN stanje_konzole sk ON o.stanje_id = sk.stanje_konzole_id
    INNER JOIN valuta v ON o.valuta_id = v.valuta_id

    WHERE o.oglas_id = @oglas_id
END

go

create procedure izmena_cene_oglasa
@oglas_id int,
@nova_cena decimal(10,2),
@valuta_id int
as
set lock_timeout 3000;
begin try
    if exists(select 1 from oglas where oglas_id = @oglas_id)
    begin
        update oglas
        set 
            cena = @nova_cena,
            valuta_id = @valuta_id
        where oglas_id = @oglas_id

        return 0
    end

    return 1
end try
begin catch
    return @@error
end catch

go

create procedure brisanje_oglasa
@oglas_id int
as
set lock_timeout 3000;
begin try
	if exists(select oglas_id from oglas
	where oglas_id = @oglas_id)
		begin
			delete from slike
			where oglas_id = @oglas_id

			delete from oglas
			where oglas_id = @oglas_id
			return 0
		end
	return 1
end try
begin catch
	return @@error
end catch

go

create procedure unos_slike
@oglas_id int,
@putanja nvarchar(255)
as
begin
	insert into slike(oglas_id, putanja)
	values(@oglas_id, @putanja)
	return 0
end

go

create procedure brisanje_slike
@slika_id int
as
set lock_timeout 3000;
begin try
	if exists(select slika_id from slike
	where slika_id = @slika_id)
		begin
			delete from slike
			where slika_id = @slika_id
			return 0
		end
	return 1
end try
begin catch
	return @@error
end catch

go

create procedure prikaz_slika_oglasa
@oglas_id int
as
set lock_timeout 3000;
begin try
	select * from slike
	where oglas_id = @oglas_id
	return 0
end try
begin catch
	return @@error
end catch

go

create trigger trigger_oglas_insert
on oglas
after insert
as
begin
	insert into oglas_audit(
		oglas_id,
		konzola_id,
		korisnik_id,
		cena,
		valuta_id,
		garancija_id,
		stanje_id,
		opis,
		datum_objave,
		memorijski_prostor,
		akcija
	)
	select
		oglas_id,
		konzola_id,
		korisnik_id,
		cena,
		valuta_id,
		garancija_id,
		stanje_id,
		opis,
		datum_objave,
		memorijski_prostor,
		'insert'
	from inserted
end

go

create trigger trigger_oglas_update
on oglas
after update
as
begin
	insert into oglas_audit(
		oglas_id,
		konzola_id,
		korisnik_id,
		cena,
		valuta_id,
		garancija_id,
		stanje_id,
		opis,
		datum_objave,
		memorijski_prostor,
		akcija
	)
	select
		oglas_id,
		konzola_id,
		korisnik_id,
		cena,
		valuta_id,
		garancija_id,
		stanje_id,
		opis,
		datum_objave,
		memorijski_prostor,
		'update'
	from inserted
end

go

create trigger trigger_oglas_delete
on oglas
after delete
as
begin
	insert into oglas_audit(
		oglas_id,
		konzola_id,
		korisnik_id,
		cena,
		valuta_id,
		garancija_id,
		stanje_id,
		opis,
		datum_objave,
		memorijski_prostor,
		akcija
	)
	select
		oglas_id,
		konzola_id,
		korisnik_id,
		cena,
		valuta_id,
		garancija_id,
		stanje_id,
		opis,
		datum_objave,
		memorijski_prostor,
		'delete'
	from deleted
end

go

CREATE PROCEDURE uzmi_marke
AS
BEGIN
    SELECT 
        marka_id,
        naziv
    FROM marka
    ORDER BY naziv
END

go

CREATE PROCEDURE uzmi_modele_po_marki
    @marka_id INT
AS
BEGIN
    SELECT 
        model_id,
        naziv
    FROM model
    WHERE marka_id = @marka_id
    ORDER BY naziv
END

go

CREATE PROCEDURE uzmi_garancije
AS
BEGIN
    SELECT 
        garancija_id,
        naziv
    FROM garancija
    ORDER BY naziv
END

go

CREATE PROCEDURE uzmi_stanja
AS
BEGIN
    SELECT 
        stanje_konzole_id,
        naziv
    FROM stanje_konzole
    ORDER BY naziv
END

go

CREATE PROCEDURE uzmi_valute
AS
BEGIN
    SELECT 
        valuta_id,
        naziv,
        simbol,
        kurs_u_eur
    FROM valuta
    ORDER BY naziv
END

go

create procedure uzmi_poslednji_oglas_id
as
begin
    select top 1 oglas_id
    from oglas
    order by oglas_id desc
end

go

CREATE PROCEDURE uzmi_sve_modele_sa_markama
AS
BEGIN
    SELECT 
        m.model_id,
        m.naziv AS model,
        ma.naziv AS marka
    FROM model m
    INNER JOIN marka ma ON m.marka_id = ma.marka_id
END

go

create procedure uzmi_konzola_id
@marka_id int,
@model_id int
as
begin
    select konzola_id
    from konzola
    where marka_id = @marka_id
      and model_id = @model_id
end

go

create procedure unos_marka
@naziv nvarchar(50)
as
begin
    if exists(select 1 from marka where naziv = @naziv)
        return 1

    insert into marka(naziv) values(@naziv)
    return 0
end

go

create procedure brisanje_marka
@marka_id int
as
begin
    delete from marka where marka_id = @marka_id
    return 0
end

go

create procedure unos_model
@marka_id int,
@naziv nvarchar(50)
as
begin
    insert into model(marka_id, naziv)
    values(@marka_id, @naziv)
    return 0
end

go

create procedure brisanje_model
@model_id int
as
begin
    delete from model where model_id = @model_id
    return 0
end

go

create procedure unos_lokacija
@ime nvarchar(100)
as
begin
    insert into lokacija(ime) values(@ime)
    return 0
end

go

create procedure brisanje_lokacija
@lokacija_id int
as
begin
    delete from lokacija where lokacija_id = @lokacija_id
    return 0
end

go

create procedure unos_stanje
@naziv nvarchar(100)
as
begin
    insert into stanje_konzole(naziv) values(@naziv)
    return 0
end

go

create procedure brisanje_stanje
@id int
as
begin
    delete from stanje_konzole where stanje_konzole_id = @id
    return 0
end

go

create procedure unos_garancija
@naziv nvarchar(100)
as
begin
    insert into garancija(naziv) values(@naziv)
    return 0
end

go

create procedure brisanje_garancija
@id int
as
begin
    delete from garancija where garancija_id = @id
    return 0
end

go

create procedure unos_valuta
@naziv nvarchar(20),
@simbol nvarchar(10),
@kurs decimal(10,4)
as
begin
    insert into valuta(naziv, simbol, kurs_u_eur)
    values(@naziv, @simbol, @kurs)
    return 0
end

go

create procedure brisanje_valuta
@id int
as
begin
    delete from valuta where valuta_id = @id
    return 0
end

go

create procedure uzmi_oglase_po_korisniku
@korisnik_id int
as
begin
    select oglas_id, naziv from oglas
    where korisnik_id = @korisnik_id
end

go

insert into marka (naziv) values
('Sony'),
('Microsoft'),
('Nintendo'),
('Sega'),
('Atari'),
('Valve');

insert into model (marka_id, naziv) values
(1, 'PlayStation 5'),
(1, 'PlayStation 5 Digital Edition'),
(1, 'PlayStation 4 Pro'),
(1, 'PlayStation 3 Slim'),

(2, 'Xbox Series X'),
(2, 'Xbox Series S'),
(2, 'Xbox One X'),
(2, 'Xbox One S'),

(3, 'Switch OLED'),
(3, 'Switch Lite'),
(3, 'Switch V2'),

(4, 'Mega Drive Mini'),
(4, 'Dreamcast'),

(5, 'Atari 2600'),
(5, 'Atari Flashback'),

(6, 'Steam Deck LCD'),
(6, 'Steam Deck OLED');

insert into lokacija (ime) values
('Beograd'), ('Novi Sad'), ('Nis'), ('Kragujevac'), ('Subotica'),
('Zrenjanin'), ('Cacak'), ('Kraljevo'), ('Pancevo'), ('Uzice');

insert into stanje_konzole (naziv) values
('Novo'),
('Kao novo'),
('Polovno'),
('Oštećeno');

insert into garancija (naziv) values
('Nema garanciju'),
('3 meseca'),
('6 meseci'),
('12 meseci'),
('24 meseca');

insert into valuta (naziv, simbol, kurs_u_eur) values
('Euro', '€', 1.0000),
('Dinar', 'RSD', 0.0085),
('Dollar', '$', 0.92)

go

insert into korisnik
(korisnik_ime, korisnik_email, korisnik_loz, korisnik_lokacija_id, korisnik_telefon, korisnik_racun, korisnik_status, korisnik_poz_ocene, korisnik_neg_ocene)
values
('Admin', 'admin@mail.com', '1234', 1, '', '', 'Admin', 0, 0),
('Marko', 'marko@mail.com', '1234', 1, '061111111', '111-111', 'Korisnik', 10, 1),
('Jovana', 'jovana@mail.com', '1234', 2, '062222222', '222-222', 'Korisnik', 8, 0),
('Nikola', 'nikola@mail.com', '1234', 3, '063333333', '333-333', 'Korisnik', 15, 2),
('Stefan', 'stefan@mail.com', '1234', 4, '064444444', '444-444', 'Korisnik', 3, 5),
('Mina', 'mina@mail.com', '1234', 5, '065555555', '555-555', 'Korisnik', 20, 0),
('Ivan', 'ivan@mail.com', '1234', 6, '061666666', '666-666', 'Korisnik', 12, 2),
('Luka', 'luka@mail.com', '1234', 7, '062777777', '777-777', 'Korisnik', 7, 1),
('Ana', 'ana@mail.com', '1234', 8, '063888888', '888-888', 'Korisnik', 18, 0),
('Milos', 'milos@mail.com', '1234', 9, '064999999', '999-999', 'Korisnik', 5, 3),
('Sara', 'sara@mail.com', '1234', 10, '065101010', '101-010', 'Korisnik', 14, 1);

insert into konzola (marka_id, model_id) values
(1, 1),
(1, 2),
(1, 3),
(2, 5),
(2, 6),
(2, 7),
(3, 9),
(3, 10),
(4, 12),
(6, 16),
(6, 17);

insert into oglas
(konzola_id, korisnik_id, naziv, cena, valuta_id, garancija_id, stanje_id, opis, datum_objave, memorijski_prostor)
values
(1, 2, 'PS5 Full Pack', 520, 1, 4, 1, 'Konzola nova, neotpakovana', '2025-12-01', '825GB'),
(2, 3, 'PS5 Digital deal', 390, 1, 3, 2, 'Odličan stanje', '2025-11-20', '825GB'),
(4, 4, 'Xbox Series X beast', 480, 1, 4, 1, 'Kao nova', '2025-12-10', '1TB'),
(5, 5, 'Xbox Series S budget', 230, 1, 1, 3, 'Malo korišćen', '2025-09-01', '512GB'),
(7, 6, 'Switch OLED bundle', 340, 1, 3, 2, 'Full kutija + igre', '2025-08-20', '64GB'),
(8, 7, 'Switch Lite pink', 180, 1, 2, 3, 'Lagano korišćen', '2025-07-10', '32GB'),
(9, 8, 'Mega Drive retro', 14000, 2, 1, 1, 'Kolekcionarski', '2025-06-01', 'N/A'),
(10, 9, 'Steam Deck OLED', 620, 1, 4, 1, 'Top stanje', '2025-12-12', '1TB');


insert into slike (oglas_id, putanja) values
(1, 'Slike\ps5_1.jpg'), (1, 'Slike\ps5_2.jpg'),
(2, 'Slike\ps5d_1.jpg'),
(3, 'Slike\xboxx_1.jpg'), (3, 'Slike\xboxx_2.jpg'),
(4, 'Slike\xboxs_1.jpg'),
(5, 'Slike\switch_1.jpg'), (5, 'Slike\switch_2.jpg'),
(6, 'Slike\lite_1.jpg'),
(7, 'Slike\sega_1.jpg'),
(8, 'Slike\steam_1.jpg'), (8, 'Slike\steam_2.jpg');