using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;

namespace NikolaMilosevicKonzoleProdajem
{
    public partial class oglas_page : System.Web.UI.Page
    {
        konekcija k = new konekcija();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int oglasId;
                if (!int.TryParse(Request.QueryString["id"], out oglasId))
                {
                    Response.Redirect("~/main.aspx");
                    return;
                }

                Session["oglas_id"] = oglasId;

                UcitajOglas(oglasId);
                UcitajSlike(oglasId);
            }
        }

        private void UcitajOglas(int oglasId)
        {
            DataTable dt = k.UzmiOglasDetaljno(oglasId);

            if (dt.Rows.Count == 0)
                return;

            DataRow row = dt.Rows[0];

            int userId = Convert.ToInt32(row["korisnik_id"]);
            Session["oglas_korisnik_id"] = userId;

            titleLabel.Text = row["naziv"].ToString();
            descriptionLabel.Text = row["opis"].ToString();
            priceLabel.Text = row["cena"].ToString() + row["simbol"].ToString();
            userNameLabel.Text = row["korisnik_ime"].ToString();
            locationLabel.Text = row["lokacija"].ToString();
            positiveLabel.Text = "Pozitivno: " + row["korisnik_poz_ocene"].ToString();
            negativeLabel.Text = "Negativno: " + row["korisnik_neg_ocene"].ToString();

            userLink.HRef = "user_page.aspx?id=" + userId;

            DateTime datum = Convert.ToDateTime(row["datum_objave"]);

            var tabela = new DataTable();
            tabela.Columns.Add("Naziv");
            tabela.Columns.Add("Vrednost");
            tabela.Rows.Add("Datum objave", datum.ToString("dd.MM.yyyy"));
            tabela.Rows.Add("Marka", row["marka"].ToString());
            tabela.Rows.Add("Model", row["model"].ToString());
            tabela.Rows.Add("Memorija", row["memorijski_prostor"].ToString());
            tabela.Rows.Add("Stanje", row["stanje"].ToString());
            tabela.Rows.Add("Garancija", row["garancija"].ToString());

            dataGrid.DataSource = tabela;
            dataGrid.DataBind();
        }

        private void UcitajSlike(int oglasId)
        {
            DataTable slike = k.PrikazSlika(oglasId);

            List<string> paths = new List<string>();
            foreach (DataRow row in slike.Rows)
                paths.Add(row["putanja"].ToString());

            Session["slike"] = paths;
            Session["slika_index"] = 0;

            PrikaziSliku();
        }

        private void PrikaziSliku()
        {
            var paths = Session["slike"] as List<string>;
            int index = Session["slika_index"] != null ? (int)Session["slika_index"] : 0;

            if (paths == null || paths.Count == 0)
            {
                oglasImage.ImageUrl = "~/img/default_image.png";
                picNumber.Text = "";
                return;
            }

            oglasImage.ImageUrl = "~/Slike/" + Path.GetFileName(paths[index]);
            picNumber.Text = (index + 1) + "/" + paths.Count;
        }

        protected void leftBtn_Click(object sender, EventArgs e)
        {
            var paths = Session["slike"] as List<string>;
            if (paths == null || paths.Count == 0) return;

            int index = (int)Session["slika_index"];
            index--;
            if (index < 0) index = paths.Count - 1;
            Session["slika_index"] = index;

            PrikaziSliku();
        }

        protected void rightBtn_Click(object sender, EventArgs e)
        {
            var paths = Session["slike"] as List<string>;
            if (paths == null || paths.Count == 0) return;

            int index = (int)Session["slika_index"];
            index++;
            if (index >= paths.Count) index = 0;
            Session["slika_index"] = index;

            PrikaziSliku();
        }
    }
}
