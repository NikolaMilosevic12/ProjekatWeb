using System;
using System.Data;

namespace NikolaMilosevicKonzoleProdajem
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["korisnik_id"] != null)
                Response.Redirect("~/main.aspx");
        }

        protected void loginButton_Click(object sender, EventArgs e)
        {
            konekcija db = new konekcija();
            int result = db.ProveraKorisnika(mailBox.Text, passwordBox.Text);

            if (result == 0)
            {
                int id = db.UzmiIdPoEmailu(mailBox.Text);
                Session["korisnik_id"] = id;

                DataTable dt = db.UzmiKorisnikaDetaljno(id);
                string status = dt.Rows[0]["korisnik_status"].ToString();

                if (status == "Admin")
                    Response.Redirect("~/admin.aspx");
                else
                    Response.Redirect("~/main.aspx");
            }
            else
            {
                poruka.Text = "Neuspesan login";
            }
        }
    }
}
