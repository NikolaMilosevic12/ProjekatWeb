using System;
using System.Collections.Generic;
using System.Configuration;
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
    }
}