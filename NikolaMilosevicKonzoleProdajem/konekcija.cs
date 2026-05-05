using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace NikolaMilosevicKonzoleProdajem
{
    public class konekcija
    {
        private SqlConnection veza;

        public konekcija()
        {
            veza = new SqlConnection(ConfigurationManager.ConnectionStrings["veza"].ConnectionString);
        }

        public SqlConnection OtvoriKonekciju()
        {
            if (veza.State == ConnectionState.Closed)
                veza.Open();

            return veza;
        }

        public void ZatvoriKonekciju()
        {
            if (veza.State == ConnectionState.Open)
                veza.Close();
        }

        private int pipeline(SqlCommand cmd)
        {
            SqlConnection veza = OtvoriKonekciju();
            cmd.Connection = veza;

            SqlParameter returnValue = new SqlParameter();
            returnValue.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(returnValue);

            cmd.ExecuteNonQuery();

            ZatvoriKonekciju();

            return (int)returnValue.Value;
        }

        public int ProveraKorisnika(string email, string lozinka)
        {
            SqlCommand command = new SqlCommand("provera_korisnika");
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@email", email);
            command.Parameters.AddWithValue("@lozinka", lozinka);

            return pipeline(command);
        }

        public int UnosKorisnika(string ime, string email, string lozinka, int lokacijaId, string telefon, string racun, string status)
        {
            SqlCommand command = new SqlCommand("unos_korisnika");
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@ime", ime);
            command.Parameters.AddWithValue("@email", email);
            command.Parameters.AddWithValue("@lozinka", lozinka);
            command.Parameters.AddWithValue("@lokacija_id", lokacijaId);
            command.Parameters.AddWithValue("@telefon", telefon);
            command.Parameters.AddWithValue("@racun", racun);
            command.Parameters.AddWithValue("@status", status);

            return pipeline(command);
        }

        public int BrisanjeKorisnika(string email, string lozinka)
        {
            SqlCommand command = new SqlCommand("brisanje_korisnika");
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@email", email);
            command.Parameters.AddWithValue("@lozinka", lozinka);

            return pipeline(command);
        }

        public int IzmenaLozinke(string email, string lozinka, string novaLozinka)
        {
            SqlCommand command = new SqlCommand("izmena_lozinke_korisnika");
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@email", email);
            command.Parameters.AddWithValue("@lozinka", lozinka);
            command.Parameters.AddWithValue("@nova_lozinka", novaLozinka);

            return pipeline(command);
        }

        public int UnosOglasa(int konzola_id, int korisnik_id, string naziv, decimal cena,
            int valuta_id, int garancija_id, int stanje_id, string opis, DateTime datum_objave, string memorijski_prostor)
        {
            SqlCommand command = new SqlCommand("unos_oglasa");
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@konzola_id", konzola_id);
            command.Parameters.AddWithValue("@korisnik_id", korisnik_id);
            command.Parameters.AddWithValue("@naziv", naziv);
            command.Parameters.AddWithValue("@cena", cena);
            command.Parameters.AddWithValue("@valuta_id", valuta_id);
            command.Parameters.AddWithValue("@garancija_id", garancija_id);
            command.Parameters.AddWithValue("@stanje_id", stanje_id);
            command.Parameters.AddWithValue("@opis", opis);
            command.Parameters.AddWithValue("@datum_objave", datum_objave);
            command.Parameters.AddWithValue("@memorijski_prostor", memorijski_prostor);

            return pipeline(command);
        }

        public int BrisanjeOglasa(int id)
        {
            SqlCommand command = new SqlCommand("brisanje_oglasa");
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@oglas_id", id);

            return pipeline(command);
        }

        public int IzmenaCeneOglasa(int id, decimal cena, int valutaId)
        {
            SqlCommand command = new SqlCommand("izmena_cene_oglasa");
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@oglas_id", id);
            command.Parameters.AddWithValue("@nova_cena", cena);
            command.Parameters.AddWithValue("@valuta_id", valutaId);

            return pipeline(command);
        }

        public DataTable UzimanjeSvihOglasa()
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzimanje_svih_oglasa_sa_korisnicima", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public int UnosSlike(int oglas_id, string putanja)
        {
            SqlCommand command = new SqlCommand("unos_slike");
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@oglas_id", oglas_id);
            command.Parameters.AddWithValue("@putanja", putanja);

            return pipeline(command);
        }

        public DataTable PrikazSlika(int oglasId)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand command = new SqlCommand("prikaz_slika_oglasa", veza);
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@oglas_id", oglasId);

            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable UzmiOglasDetaljno(int oglasId)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_oglas_detaljno", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@oglas_id", oglasId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable FilterOglasa(int? cenaMin, int? cenaMax, int? lokacijaId, int? garancijaId, int? stanjeId)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("filter_oglasa", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@cena_min", (object)cenaMin ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@cena_max", (object)cenaMax ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@lokacija", (object)lokacijaId ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@garancija", (object)garancijaId ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@stanje", (object)stanjeId ?? DBNull.Value);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable UzmiLokacije()
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("select lokacija_id, ime from lokacija", veza);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable Search(string tekst)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("search", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@tekst",
                string.IsNullOrWhiteSpace(tekst)
                ? (object)DBNull.Value
                : tekst);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable SearchFilterOglasa(string tekst, int? cenaMin, int? cenaMax, int? lokacijaId, int? garancijaId, int? stanjeId)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("search_filter_oglasa", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@tekst",
                string.IsNullOrWhiteSpace(tekst)
                ? (object)DBNull.Value
                : tekst);

            cmd.Parameters.AddWithValue("@cena_min", (object)cenaMin ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@cena_max", (object)cenaMax ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@lokacija", (object)lokacijaId ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@garancija", (object)garancijaId ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@stanje", (object)stanjeId ?? DBNull.Value);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable UzmiKorisnikaDetaljno(int korisnikId)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_korisnika_detaljno", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@korisnik_id", korisnikId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public int UzmiIdPoEmailu(string email)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_id_po_emailu", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@email", email);

            object rezultat = cmd.ExecuteScalar();

            ZatvoriKonekciju();

            if (rezultat != null && rezultat != DBNull.Value)
                return Convert.ToInt32(rezultat);

            return -1;
        }

        public DataTable UzmiMarke()
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_marke", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable UzmiModelePoMarki(int markaId)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_modele_po_marki", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@marka_id", markaId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable UzmiGarancije()
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_garancije", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable UzmiStanja()
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_stanja", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public DataTable UzmiValute()
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_valute", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public int UzmiKonzolaId(int markaId, int modelId)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_konzola_id", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@marka_id", markaId);
            cmd.Parameters.AddWithValue("@model_id", modelId);

            object rezultat = cmd.ExecuteScalar();

            ZatvoriKonekciju();

            if (rezultat != null && rezultat != DBNull.Value)
                return Convert.ToInt32(rezultat);

            return -1;
        }

        public int UzmiPoslednjiOglasId()
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_poslednji_oglas_id", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            object rezultat = cmd.ExecuteScalar();

            ZatvoriKonekciju();

            if (rezultat != null && rezultat != DBNull.Value)
                return Convert.ToInt32(rezultat);

            return -1;
        }

        public DataTable UzmiSveModeleSaMarkama()
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_sve_modele_sa_markama", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }

        public int UnosMarka(string naziv)
        {
            SqlCommand cmd = new SqlCommand("unos_marka");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@naziv", naziv);

            return pipeline(cmd);
        }

        public int BrisanjeMarka(int id)
        {
            SqlCommand cmd = new SqlCommand("brisanje_marka");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@marka_id", id);

            return pipeline(cmd);
        }

        public int UnosModel(int markaId, string naziv)
        {
            SqlCommand cmd = new SqlCommand("unos_model");
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@marka_id", markaId);
            cmd.Parameters.AddWithValue("@naziv", naziv);

            return pipeline(cmd);
        }

        public int BrisanjeModel(int id)
        {
            SqlCommand cmd = new SqlCommand("brisanje_model");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@model_id", id);

            return pipeline(cmd);
        }

        public int UnosLokacija(string ime)
        {
            SqlCommand cmd = new SqlCommand("unos_lokacija");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ime", ime);

            return pipeline(cmd);
        }

        public int BrisanjeLokacija(int id)
        {
            SqlCommand cmd = new SqlCommand("brisanje_lokacija");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@lokacija_id", id);

            return pipeline(cmd);
        }

        public int UnosStanje(string naziv)
        {
            SqlCommand cmd = new SqlCommand("unos_stanje");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@naziv", naziv);

            return pipeline(cmd);
        }

        public int BrisanjeStanje(int id)
        {
            SqlCommand cmd = new SqlCommand("brisanje_stanje");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            return pipeline(cmd);
        }

        public int UnosGarancija(string naziv)
        {
            SqlCommand cmd = new SqlCommand("unos_garancija");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@naziv", naziv);

            return pipeline(cmd);
        }

        public int BrisanjeGarancija(int id)
        {
            SqlCommand cmd = new SqlCommand("brisanje_garancija");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            return pipeline(cmd);
        }

        public int UnosValuta(string naziv, string simbol, decimal kurs)
        {
            SqlCommand cmd = new SqlCommand("unos_valuta");
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@naziv", naziv);
            cmd.Parameters.AddWithValue("@simbol", simbol);
            cmd.Parameters.AddWithValue("@kurs", kurs);

            return pipeline(cmd);
        }

        public int BrisanjeValuta(int id)
        {
            SqlCommand cmd = new SqlCommand("brisanje_valuta");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            return pipeline(cmd);
        }

        public DataTable UzmiOglasePoKorisniku(int korisnikId)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand cmd = new SqlCommand("uzmi_oglase_po_korisniku", veza);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@korisnik_id", korisnikId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);

            ZatvoriKonekciju();
            return dt;
        }
    }
}
