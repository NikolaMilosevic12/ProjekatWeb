using System;
using System.Data;

namespace NikolaMilosevicKonzoleProdajem
{
    public partial class register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["korisnik_id"] != null)
                Response.Redirect("~/main.aspx");

            if (!IsPostBack)
            {
                konekcija db = new konekcija();
                DataTable lokacije = db.UzmiLokacije();
                DataRow lrow = lokacije.NewRow();
                lrow["lokacija_id"] = -1;
                lrow["ime"] = "Lokacija";
                lokacije.Rows.InsertAt(lrow, 0);

                locationBox.DataSource = lokacije;
                locationBox.DataTextField = "ime";
                locationBox.DataValueField = "lokacija_id";
                locationBox.DataBind();
            }
        }

        protected void registrationButton_Click(object sender, EventArgs e)
        {
            if (locationBox.SelectedValue == "-1")
            {
                poruka.Text = "Niste izabrali lokaciju";
                return;
            }

            konekcija db = new konekcija();
            int result = db.UnosKorisnika(
                nameBox.Text,
                mailBox.Text,
                passwordBox.Text,
                Convert.ToInt32(locationBox.SelectedValue),
                phoneBox.Text,
                racunBox.Text,
                "Korisnik"
            );

            if (result == 0)
            {
                int id = db.UzmiIdPoEmailu(mailBox.Text);
                Session["korisnik_id"] = id;
                Response.Redirect("~/main.aspx");
            }
            else if (result == 1)
            {
                poruka.Text = "Mejl je vec koriscen";
            }
            else if (result == 2)
            {
                poruka.Text = "Telefon je vec koriscen";
            }
            else
            {
                poruka.Text = "Neuspesna registracija";
            }
        }
    }
}
