using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NikolaMilosevicKonzoleProdajem
{
    public partial class Site : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["korisnik_id"] != null)
            {
                loginLink.Visible = false;
                profileLink.Visible = true;
                profileLink.NavigateUrl = "~/user_page.aspx?id=" + Session["korisnik_id"].ToString();
            }
            else
            {
                loginLink.Visible = true;
                profileLink.Visible = false;
            }
        }

        protected void searchButton_Click(object sender, EventArgs e)
        {
            string tekst = searchBar.Text.Trim();
            Response.Redirect("~/main.aspx?q=" + Server.UrlEncode(tekst));
        }
    }
}
