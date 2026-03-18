using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace NikolaMilosevic
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
            if (veza.State == System.Data.ConnectionState.Closed) veza.Open();
            return veza;
        }

        public void ZatvoriKonekciju()
        {
            if (veza.State == System.Data.ConnectionState.Open) veza.Close();
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

        public int UnosKorisnika(string email, string lozinka)
        {
            SqlCommand command = new SqlCommand("unos_korisnika");
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@email", email);
            command.Parameters.AddWithValue("@lozinka", lozinka);
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

        public int UnosKonzole(string marka, string model, string memorija)
        {
            SqlCommand command = new SqlCommand("unos_konzola");
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@marka", marka);
            command.Parameters.AddWithValue("@model", model);
            command.Parameters.AddWithValue("@memorijski_prostor", memorija);
            return pipeline(command);
        }

        public int BrisanjeKonzole(int id)
        {
            SqlCommand command = new SqlCommand("brisanje_konzola");
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@konzola_id", id);
            return pipeline(command);
        }

        public int UnosOglasa(string konzola_id, decimal cena, int garancija, string stanje, string opis, DateTime datum_objave, int starost_u_mesecima)
        {
            SqlCommand command = new SqlCommand("unos_oglasa");
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@konzola_id", konzola_id);
            command.Parameters.AddWithValue("@cena", cena);
            command.Parameters.AddWithValue("@garancija", garancija);
            command.Parameters.AddWithValue("@stanje", stanje);
            command.Parameters.AddWithValue("@opis", opis);
            command.Parameters.AddWithValue("@datum_objave", datum_objave);
            command.Parameters.AddWithValue("@starost_u_mesecima", starost_u_mesecima);
            return pipeline(command);
        }

        public int BrisanjeOglasa(int id)
        {
            SqlCommand command = new SqlCommand("brisanje_oglasa");
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@oglas_id", id);
            return pipeline(command);
        }
        public int IzmenaCeneOglasa(int id, decimal cena)
        {
            SqlCommand command = new SqlCommand("izmena_cene_oglasa");
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@oglas_id", id);
            command.Parameters.AddWithValue("@nova_cena", cena);
            return pipeline(command);
        }

        public int UnosSlike(int oglas_id, string putanja)
        {
            SqlCommand command = new SqlCommand("unos_slike");
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@oglas_id", oglas_id);
            command.Parameters.AddWithValue("@putanja", putanja);
            return pipeline(command);
        }

        public int BrisanjeSlike(int id)
        {
            SqlCommand command = new SqlCommand("brisanje_slike");
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@slika_id", id);
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
    }
}