using System;
using System.Data;
using System.Web.UI.WebControls;

namespace NikolaMilosevicKonzoleProdajem
{
    public partial class admin : System.Web.UI.Page
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
                refresh();
        }

        private void SrediGrid(GridView dgv)
        {
            dgv.AutoGenerateColumns = true;
            dgv.RowStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Left;
        }

        private void refresh()
        {
            markaGrid.DataSource = db.UzmiMarke();
            markaGrid.DataBind();

            lokacijaGrid.DataSource = db.UzmiLokacije();
            lokacijaGrid.DataBind();

            stanjeGrid.DataSource = db.UzmiStanja();
            stanjeGrid.DataBind();

            garancijaGrid.DataSource = db.UzmiGarancije();
            garancijaGrid.DataBind();

            valutaGrid.DataSource = db.UzmiValute();
            valutaGrid.DataBind();

            modelGrid.DataSource = db.UzmiSveModeleSaMarkama();
            modelGrid.DataBind();

            DataTable marke = db.UzmiMarke();

            markaComboBox.DataSource = marke;
            markaComboBox.DataTextField = "naziv";
            markaComboBox.DataValueField = "marka_id";
            markaComboBox.DataBind();

            modelMarkaBox.DataSource = marke;
            modelMarkaBox.DataTextField = "naziv";
            modelMarkaBox.DataValueField = "marka_id";
            modelMarkaBox.DataBind();

            modelMarkaComboBox.DataSource = marke;
            modelMarkaComboBox.DataTextField = "naziv";
            modelMarkaComboBox.DataValueField = "marka_id";
            modelMarkaComboBox.DataBind();

            if (marke.Rows.Count > 0)
            {
                modelComboBox.DataSource = db.UzmiModelePoMarki(Convert.ToInt32(modelMarkaComboBox.SelectedValue));
                modelComboBox.DataTextField = "naziv";
                modelComboBox.DataValueField = "model_id";
                modelComboBox.DataBind();
            }

            garancijaComboBox.DataSource = db.UzmiGarancije();
            garancijaComboBox.DataTextField = "naziv";
            garancijaComboBox.DataValueField = "garancija_id";
            garancijaComboBox.DataBind();

            lokacijaComboBox.DataSource = db.UzmiLokacije();
            lokacijaComboBox.DataTextField = "ime";
            lokacijaComboBox.DataValueField = "lokacija_id";
            lokacijaComboBox.DataBind();

            stanjeComboBox.DataSource = db.UzmiStanja();
            stanjeComboBox.DataTextField = "naziv";
            stanjeComboBox.DataValueField = "stanje_konzole_id";
            stanjeComboBox.DataBind();

            valutaComboBox.DataSource = db.UzmiValute();
            valutaComboBox.DataTextField = "naziv";
            valutaComboBox.DataValueField = "valuta_id";
            valutaComboBox.DataBind();
        }

        protected void markeButton_Click(object sender, EventArgs e)
        {
            db.UnosMarka(markeBox.Text);
            refresh();
        }

        protected void lokacijaButton_Click(object sender, EventArgs e)
        {
            db.UnosLokacija(lokacijaBox.Text);
            refresh();
        }

        protected void modelButton_Click(object sender, EventArgs e)
        {
            db.UnosModel(Convert.ToInt32(modelMarkaBox.SelectedValue), modelBox.Text);
            refresh();
        }

        protected void stanjeButton_Click(object sender, EventArgs e)
        {
            db.UnosStanje(stanjeBox.Text);
            refresh();
        }

        protected void garancijaButton_Click(object sender, EventArgs e)
        {
            db.UnosGarancija(garancijaBox.Text);
            refresh();
        }

        protected void valutaButton_Click(object sender, EventArgs e)
        {
            try
            {
                db.UnosValuta(valutaImeBox.Text, valutaSimbolBox.Text, Convert.ToDecimal(valutaKursBox.Text));
                refresh();
            }
            catch
            {
                poruka.Text = "Lose unet kurs";
            }
        }

        protected void markaDeleteButton_Click(object sender, EventArgs e)
        {
            try
            {
                db.BrisanjeMarka(Convert.ToInt32(markaComboBox.SelectedValue));
                refresh();
            }
            catch
            {
                poruka.Text = "Nije moguce obrisati ovu marku dok se svi modeli pod njom ne obrisu";
            }
        }

        protected void lokacijaDeleteButton_Click(object sender, EventArgs e)
        {
            db.BrisanjeLokacija(Convert.ToInt32(lokacijaComboBox.SelectedValue));
            refresh();
        }

        protected void modelDeleteButton_Click(object sender, EventArgs e)
        {
            db.BrisanjeModel(Convert.ToInt32(modelComboBox.SelectedValue));
            refresh();
        }

        protected void stanjeDeleteButton_Click(object sender, EventArgs e)
        {
            db.BrisanjeStanje(Convert.ToInt32(stanjeComboBox.SelectedValue));
            refresh();
        }

        protected void garancijaDeleteButton_Click(object sender, EventArgs e)
        {
            db.BrisanjeGarancija(Convert.ToInt32(garancijaComboBox.SelectedValue));
            refresh();
        }

        protected void valutaDeleteButton_Click(object sender, EventArgs e)
        {
            db.BrisanjeValuta(Convert.ToInt32(valutaComboBox.SelectedValue));
            refresh();
        }

        protected void modelMarkaComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (modelMarkaComboBox.SelectedValue == null)
                return;

            if (!int.TryParse(modelMarkaComboBox.SelectedValue, out int markaId))
                return;

            modelComboBox.DataSource = db.UzmiModelePoMarki(markaId);
            modelComboBox.DataTextField = "naziv";
            modelComboBox.DataValueField = "model_id";
            modelComboBox.DataBind();
        }

        protected void logoutButton_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/main.aspx");
        }
    }
}
