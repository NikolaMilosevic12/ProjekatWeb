using System;
using System.Data;

namespace NikolaMilosevic
{
    public partial class Test : System.Web.UI.Page
    {
        konekcija db = new konekcija();

        // ===== KORISNIK =====
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Provera: " + db.ProveraKorisnika(txtEmail.Text, txtLozinka.Text);
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Unos: " + db.UnosKorisnika(
                txtEmail.Text,
                txtLozinka.Text,
                txtTelefon.Text,
                txtRacun.Text,
                txtStatus.Text
            );
        }

        protected void btnDeleteUser_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Brisanje: " + db.BrisanjeKorisnika(txtEmail.Text, txtLozinka.Text);
        }

        protected void btnChangePass_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Izmena: " + db.IzmenaLozinke(
                txtEmail.Text,
                txtLozinka.Text,
                txtNovaLozinka.Text
            );
        }

        // ===== KONZOLA =====
        protected void btnAddKonzola_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Konzola: " + db.UnosKonzole(
                txtMarka.Text,
                txtModel.Text,
                txtMemorija.Text
            );
        }

        protected void btnDeleteKonzola_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Brisanje konzole: " + db.BrisanjeKonzole(
                int.Parse(txtKonzolaId.Text)
            );
        }

        // ===== OGLAS =====
        protected void btnAddOglas_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Oglas: " + db.UnosOglasa(
                txtOglasKonzolaId.Text,
                decimal.Parse(txtCena.Text),
                int.Parse(txtGarancija.Text),
                txtStanje.Text,
                txtOpis.Text,
                DateTime.Now,
                int.Parse(txtStarost.Text)
            );
        }

        protected void btnDeleteOglas_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Brisanje oglasa: " + db.BrisanjeOglasa(
                int.Parse(txtOglasId.Text)
            );
        }

        protected void btnUpdateCena_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Izmena cene: " + db.IzmenaCeneOglasa(
                int.Parse(txtOglasId.Text),
                decimal.Parse(txtCena.Text)
            );
        }

        // ===== SLIKE =====
        protected void btnAddSlika_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Slika: " + db.UnosSlike(
                int.Parse(txtSlikaOglasId.Text),
                txtPutanja.Text
            );
        }

        protected void btnDeleteSlika_Click(object sender, EventArgs e)
        {
            lblResult.Text = "Brisanje slike: " + db.BrisanjeSlike(
                int.Parse(txtSlikaId.Text)
            );
        }

        protected void btnPrikazSlika_Click(object sender, EventArgs e)
        {
            DataTable dt = db.PrikazSlika(int.Parse(txtSlikaOglasId.Text));
            gridSlike.DataSource = dt;
            gridSlike.DataBind();
        }
    }
}