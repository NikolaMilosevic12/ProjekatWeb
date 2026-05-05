using System;
using System.Data;

namespace NikolaMilosevicKonzoleProdajem
{
    public partial class main : System.Web.UI.Page
    {
        konekcija db = new konekcija();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopuniFiltre();

                string q = Request.QueryString["q"];
                PrikaziOglase(q);
            }
        }

        private void PopuniFiltre()
        {
            DataTable lokacije = db.UzmiLokacije();
            DataRow lrow = lokacije.NewRow();
            lrow["lokacija_id"] = -1;
            lrow["ime"] = "Sve";
            lokacije.Rows.InsertAt(lrow, 0);
            lokacijaFilterList.DataSource = lokacije;
            lokacijaFilterList.DataTextField = "ime";
            lokacijaFilterList.DataValueField = "lokacija_id";
            lokacijaFilterList.DataBind();

            DataTable garancije = db.UzmiGarancije();
            DataRow grow = garancije.NewRow();
            grow["garancija_id"] = -1;
            grow["naziv"] = "Sve";
            garancije.Rows.InsertAt(grow, 0);
            garancijaFilterList.DataSource = garancije;
            garancijaFilterList.DataTextField = "naziv";
            garancijaFilterList.DataValueField = "garancija_id";
            garancijaFilterList.DataBind();

            DataTable stanja = db.UzmiStanja();
            DataRow srow = stanja.NewRow();
            srow["stanje_konzole_id"] = -1;
            srow["naziv"] = "Sve";
            stanja.Rows.InsertAt(srow, 0);
            stanjeFilterList.DataSource = stanja;
            stanjeFilterList.DataTextField = "naziv";
            stanjeFilterList.DataValueField = "stanje_konzole_id";
            stanjeFilterList.DataBind();
        }

        private string PreKolikoJePostavljeno(DateTime datum)
        {
            TimeSpan diff = DateTime.Now - datum;

            if (diff.TotalDays >= 365)
                return "pre " + (int)(diff.TotalDays / 365) + " god";

            if (diff.TotalDays >= 30)
                return "pre " + (int)(diff.TotalDays / 30) + " mes";

            if (diff.TotalDays >= 1)
                return "pre " + (int)diff.TotalDays + " dana";

            if (diff.TotalHours >= 1)
                return "pre " + (int)diff.TotalHours + " sati";

            if (diff.TotalMinutes >= 1)
                return "pre " + (int)diff.TotalMinutes + " min";

            return "sad";
        }

        private void PrikaziOglase(string tekst)
        {
            int? min = int.TryParse(cenaMinBox.Text, out int c1) ? c1 : (int?)null;
            int? max = int.TryParse(cenaMaxBox.Text, out int c2) ? c2 : (int?)null;

            int? lokacijaId = int.TryParse(lokacijaFilterList.SelectedValue, out int l) && l != -1 ? l : (int?)null;
            int? garancijaId = int.TryParse(garancijaFilterList.SelectedValue, out int g) && g != -1 ? g : (int?)null;
            int? stanjeId = int.TryParse(stanjeFilterList.SelectedValue, out int s) && s != -1 ? s : (int?)null;

            DataTable dt = db.SearchFilterOglasa(tekst, min, max, lokacijaId, garancijaId, stanjeId);

            dt.Columns.Add("timeAgo", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                if (row["datum_objave"] != DBNull.Value)
                    row["timeAgo"] = PreKolikoJePostavljeno(Convert.ToDateTime(row["datum_objave"]));
                else
                    row["timeAgo"] = "";
            }

            oglasi.DataSource = dt;
            oglasi.DataBind();
        }

        protected void primeniButton_Click(object sender, EventArgs e)
        {
            string q = Request.QueryString["q"];
            PrikaziOglase(q);
        }
    }
}
