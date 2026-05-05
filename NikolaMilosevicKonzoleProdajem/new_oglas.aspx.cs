using System;
using System.Data;
using System.IO;
using System.Web;

namespace NikolaMilosevicKonzoleProdajem
{
    public partial class new_oglas : System.Web.UI.Page
    {
        konekcija db = new konekcija();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["korisnik_id"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            if (!IsPostBack)
                PopuniFormu();
        }

        private void PopuniFormu()
        {
            valutaBox.DataSource = db.UzmiValute();
            valutaBox.DataTextField = "simbol";
            valutaBox.DataValueField = "valuta_id";
            valutaBox.DataBind();

            markaBox.DataSource = db.UzmiMarke();
            markaBox.DataTextField = "naziv";
            markaBox.DataValueField = "marka_id";
            markaBox.DataBind();

            if (markaBox.Items.Count > 0)
                PopuniModele(Convert.ToInt32(markaBox.SelectedValue));

            stanjeBox.DataSource = db.UzmiStanja();
            stanjeBox.DataTextField = "naziv";
            stanjeBox.DataValueField = "stanje_konzole_id";
            stanjeBox.DataBind();

            garancijaBox.DataSource = db.UzmiGarancije();
            garancijaBox.DataTextField = "naziv";
            garancijaBox.DataValueField = "garancija_id";
            garancijaBox.DataBind();
        }

        private void PopuniModele(int markaId)
        {
            modelBox.DataSource = db.UzmiModelePoMarki(markaId);
            modelBox.DataTextField = "naziv";
            modelBox.DataValueField = "model_id";
            modelBox.DataBind();
        }

        protected void markaBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopuniModele(Convert.ToInt32(markaBox.SelectedValue));
        }

        private string SacuvajSliku(HttpPostedFile file, int br_oglasa, int br_slike)
        {
            string extension = Path.GetExtension(file.FileName);
            string filename = "oglas" + br_oglasa + "_" + br_slike + extension;
            string folderPath = Server.MapPath("~/Slike/");

            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            file.SaveAs(Path.Combine(folderPath, filename));
            return "Slike/" + filename;
        }

        protected void finishButton_Click(object sender, EventArgs e)
        {
            try
            {
                int marka_id = Convert.ToInt32(markaBox.SelectedValue);
                int model_id = Convert.ToInt32(modelBox.SelectedValue);
                int konzola_id = db.UzmiKonzolaId(marka_id, model_id);

                if (konzola_id == -1)
                {
                    poruka.Text = "Konzola za izabranu marku i model ne postoji!";
                    return;
                }

                decimal cena;
                if (!decimal.TryParse(priceBox.Text, out cena))
                {
                    poruka.Text = "Cena nije validna!";
                    return;
                }

                int korisnikId = Convert.ToInt32(Session["korisnik_id"]);
                int valuta_id = Convert.ToInt32(valutaBox.SelectedValue);
                int stanje_id = Convert.ToInt32(stanjeBox.SelectedValue);
                int garancija_id = Convert.ToInt32(garancijaBox.SelectedValue);

                int result = db.UnosOglasa(
                    konzola_id,
                    korisnikId,
                    nameBox.Text,
                    cena,
                    valuta_id,
                    garancija_id,
                    stanje_id,
                    descriptionBox.Text,
                    DateTime.Now,
                    memorijaBox.Text
                );

                if (result == 0)
                {
                    int oglasId = db.UzmiPoslednjiOglasId();

                    if (fileUpload.HasFiles)
                    {
                        int br = 1;
                        foreach (HttpPostedFile file in fileUpload.PostedFiles)
                        {
                            string putanja = SacuvajSliku(file, oglasId, br);
                            db.UnosSlike(oglasId, putanja);
                            br++;
                        }
                    }

                    Response.Redirect("~/main.aspx");
                }
                else
                {
                    poruka.Text = "Neuspesno postavljanje oglasa";
                }
            }
            catch (Exception ex)
            {
                poruka.Text = "Greska: " + ex.Message;
            }
        }
    }
}
