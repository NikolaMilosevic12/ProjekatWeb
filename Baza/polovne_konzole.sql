create database nikola410

go

use nikola410

go

create table korisnik (
	korisnik_id int PRIMARY KEY IDENTITY(1,1),
	korisnik_email nvarchar(20),
	korisnik_loz nvarchar(20),
	korisnik_telefon nvarchar(20),
	korisnik_racun nvarchar(30),
	korisnik_status nvarchar(20)
)

go

create table konzola (
	konzola_id int PRIMARY KEY IDENTITY(1,1),
	marka nvarchar(50) not null,
	model nvarchar(50) not null,
	memorijski_prostor nvarchar(10)
)

go

create table slike (
    slika_id int PRIMARY KEY IDENTITY(1,1),
    oglas_id int,
    putanja nvarchar(255)
)

go

create table oglas (
    oglas_id int PRIMARY KEY IDENTITY(1,1),
    konzola_id int,
	korisnik_id int,
    cena int,
    garancija int,
    stanje nvarchar(50),
    opis nvarchar(400),
    datum_objave date,
    starost_u_mesecima int
)

go

create table oglas_audit (
    oglas_id int PRIMARY KEY IDENTITY(1,1),
    konzola_id int,
	korisnik_id int,
    cena int,
    garancija int,
    stanje nvarchar(50),
    opis nvarchar(400),
    datum_objave date,
    starost_u_mesecima int,
	akcija nvarchar(10),
	vreme_akcije datetime default getdate()
)

go

ALTER TABLE slike
ADD CONSTRAINT FK_SlikeOglas
FOREIGN KEY (oglas_id) REFERENCES oglas(oglas_id)

go

ALTER TABLE oglas
ADD CONSTRAINT FK_Oglaskonzola
FOREIGN KEY (konzola_id) REFERENCES konzola(konzola_id)

go

ALTER TABLE oglas
ADD CONSTRAINT FK_OglasKorisnik
FOREIGN KEY (korisnik_id) REFERENCES korisnik(korisnik_id)

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

create procedure unos_korisnika
@email nvarchar(50),
@lozinka nvarchar(100),
@telefon nvarchar(20),
@racun nvarchar(30),
@status nvarchar(20)
as
set lock_timeout 3000;
begin try
	declare @rez int;
	exec @rez = provera_korisnika @email, @lozinka
	if @rez=1
		begin
			insert into korisnik(korisnik_email, korisnik_loz, korisnik_telefon, korisnik_racun, korisnik_status) values (@email, @lozinka, @telefon, @racun, @status)
			return 0
		end
	return 1
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

create procedure unos_konzola
@marka nvarchar(50),
@model nvarchar(50),
@memorijski_prostor nvarchar(10)
as
set lock_timeout 3000;
begin try
	insert into konzola(marka, model, memorijski_prostor)
	values(@marka, @model, @memorijski_prostor)
	return 0
end try
begin catch
	return @@error
end catch

go

create procedure brisanje_konzola
@konzola_id int
as
set lock_timeout 3000;
begin try
	delete from konzola
	where konzola_id = @konzola_id
	return 0
end try
begin catch
	return @@error
end catch

go

create procedure unos_oglasa
@konzola_id int,
@cena decimal(10,2),
@garancija int,
@stanje nvarchar(50),
@opis nvarchar(400),
@datum_objave date,
@starost_u_mesecima int
as
set lock_timeout 3000;
begin try
	insert into oglas(konzola_id, cena, garancija, stanje, opis, datum_objave, starost_u_mesecima)
	values(@konzola_id, @cena, @garancija, @stanje, @opis, @datum_objave, @starost_u_mesecima)
	return 0
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
	delete from slike
	where oglas_id = @oglas_id
	delete from oglas
	where oglas_id = @oglas_id
	return 0
end try
begin catch
	return @@error
end catch

go

create procedure izmena_cene_oglasa
@oglas_id int,
@nova_cena decimal(10,2)
as
set lock_timeout 3000;
begin try
	update oglas
	set cena = @nova_cena
	where oglas_id = @oglas_id
	return 0
end try
begin catch
	return @@error
end catch

go

create procedure unos_slike
@oglas_id int,
@putanja nvarchar(255)
as
set lock_timeout 3000;
begin try
	insert into slike(oglas_id, putanja)
	values(@oglas_id, @putanja)
	return 0
end try
begin catch
	return @@error
end catch

go

create procedure brisanje_slike
@slika_id int
as
set lock_timeout 3000;
begin try
	delete from slike
	where slika_id = @slika_id
	return 0
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
    insert into oglas_audit(oglas_id, konzola_id, korisnik_id, cena, garancija, stanje, opis, datum_objave, starost_u_mesecima, akcija)
    select oglas_id, konzola_id, korisnik_id, cena, garancija, stanje, opis, datum_objave, starost_u_mesecima, 'insert'
    from inserted
end

go

create trigger trigger_oglas_update
on oglas
after update
as
begin
    insert into oglas_audit(oglas_id, konzola_id, korisnik_id, cena, garancija, stanje, opis, datum_objave, starost_u_mesecima, akcija)
    select oglas_id, konzola_id, korisnik_id, cena, garancija, stanje, opis, datum_objave, starost_u_mesecima, 'update'
    from inserted
end

go

create trigger trigger_oglas_delete
on oglas
after delete
as
begin
    insert into oglas_audit(oglas_id, konzola_id, korisnik_id, cena, garancija, stanje, opis, datum_objave, starost_u_mesecima, akcija)
    select oglas_id, konzola_id, korisnik_id, cena, garancija, stanje, opis, datum_objave, starost_u_mesecima, 'delete'
    from deleted
end