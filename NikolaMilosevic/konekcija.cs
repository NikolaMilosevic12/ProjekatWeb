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

        public int ProveraKorisnika(string email, string lozinka)
        {
            SqlConnection veza = OtvoriKonekciju();

            SqlCommand command = new SqlCommand("provera_korisnika", veza);
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@email", email);
            command.Parameters.AddWithValue("@lozinka", lozinka);

            SqlParameter returnValue = new SqlParameter();
            returnValue.Direction = ParameterDirection.ReturnValue;
            command.Parameters.Add(returnValue);

            command.ExecuteNonQuery();

            ZatvoriKonekciju();

            return (int)returnValue.Value;
        }


    }
}