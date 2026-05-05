using System;
using System.Data;

namespace NikolaMilosevicKonzoleProdajem
{
    public partial class user_page : System.Web.UI.Page
    {
        konekcija db = new konekcija();
        int userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out userId))
            {
                Response.Redirect("~/main.aspx");
                return;
            }

            if (!IsPostBack)
            {
                UcitajKorisnika();

                bool isOwner = Session["korisnik_id"] != null && Convert.ToInt32(Session["korisnik_id"]) == userId;
                mojaStrana.Visible = isOwner;

                if (isOwner)
                    PopuniMojuStranu();
            }
        }

        private void UcitajKorisnika()
        {
            DataTable dt = db.UzmiKorisnikaDetaljno(userId);

            if (dt.Rows.Count == 0)
                return;

            DataRow row = dt.Rows[0];
            nameLabel.Text = row["korisnik_ime"].ToString();
            emailLabel.Text = row["korisnik_email"].ToString();
            telefonLabel.Text = row["korisnik_telefon"].ToString();
            racunLabel.Text = row["korisnik_racun"].ToString();
            locationLabel.Text = row["lokacija"].ToString();
            pozLabel.Text = row["korisnik_poz_ocene"].ToString();
            negLabel.Text = row["korisnik_neg_ocene"].ToString();
        }

        private void PopuniMojuStranu()
        {
            DataTable valute = db.UzmiValute();
            valutaBox.DataSource = valute;
            valutaBox.DataTextField = "simbol";
            valutaBox.DataValueField = "valuta_id";
            valutaBox.DataBind();

            DataTable oglasi = db.UzmiOglasePoKorisniku(userId);
            changeOglasBox.DataSource = oglasi;
            changeOglasBox.DataTextField = "naziv";
            changeOglasBox.DataValueField = "oglas_id";
            changeOglasBox.DataBind();

            deleteBox.DataSource = oglasi;
            deleteBox.DataTextField = "naziv";
            deleteBox.DataValueField = "oglas_id";
            deleteBox.DataBind();
        }

        protected void changeButton_Click(object sender, EventArgs e)
        {
            decimal cena;
            if (!decimal.TryParse(priceBox.Text, out cena))
            {
                poruka.Text = "Cena nije validna";
                return;
            }

            int result = db.IzmenaCeneOglasa(
                Convert.ToInt32(changeOglasBox.SelectedValue),
                cena,
                Convert.ToInt32(valutaBox.SelectedValue)
            );

            poruka.Text = result == 0 ? "Uspesna promena cene" : "Neuspesna promena cene";
            PopuniMojuStranu();
        }

        protected void deleteButton_Click(object sender, EventArgs e)
        {
            int result = db.BrisanjeOglasa(Convert.ToInt32(deleteBox.SelectedValue));
            poruka.Text = result == 0 ? "Uspesno brisanje oglasa" : "Neuspesno brisanje oglasa";
            PopuniMojuStranu();
        }

        protected void logoutButton_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/main.aspx");
        }
    }
}
