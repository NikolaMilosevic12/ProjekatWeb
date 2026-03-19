<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="NikolaMilosevic.Test" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>DB Test Panel</title>
</head>
<body>
<form id="form1" runat="server">

<h1>🧪 Test Panel</h1>

<!-- ================= KORISNIK ================= -->
<h2>Korisnik</h2>
Email: <asp:TextBox ID="txtEmail" runat="server" /><br />
Lozinka: <asp:TextBox ID="txtLozinka" runat="server" /><br />
Nova lozinka: <asp:TextBox ID="txtNovaLozinka" runat="server" /><br /><br />
Telefon: <asp:TextBox ID="txtTelefon" runat="server" /><br />
Racun: <asp:TextBox ID="txtRacun" runat="server" /><br />
Status: <asp:TextBox ID="txtStatus" runat="server" /><br /><br />

<asp:Button ID="btnLogin" runat="server" Text="Provera" OnClick="btnLogin_Click" />
<asp:Button ID="btnRegister" runat="server" Text="Unos" OnClick="btnRegister_Click" />
<asp:Button ID="btnDeleteUser" runat="server" Text="Brisanje" OnClick="btnDeleteUser_Click" />
<asp:Button ID="btnChangePass" runat="server" Text="Izmena lozinke" OnClick="btnChangePass_Click" />

<hr />

<!-- ================= KONZOLA ================= -->
<h2>Konzola</h2>
ID: <asp:TextBox ID="txtKonzolaId" runat="server" /><br />
Marka: <asp:TextBox ID="txtMarka" runat="server" /><br />
Model: <asp:TextBox ID="txtModel" runat="server" /><br />
Memorija: <asp:TextBox ID="txtMemorija" runat="server" /><br /><br />

<asp:Button ID="btnAddKonzola" runat="server" Text="Unos Konzole" OnClick="btnAddKonzola_Click" />
<asp:Button ID="btnDeleteKonzola" runat="server" Text="Brisanje Konzole" OnClick="btnDeleteKonzola_Click" />

<hr />

<!-- ================= OGLAS ================= -->
<h2>Oglas</h2>
Oglas ID: <asp:TextBox ID="txtOglasId" runat="server" /><br />
Konzola ID: <asp:TextBox ID="txtOglasKonzolaId" runat="server" /><br />
Cena: <asp:TextBox ID="txtCena" runat="server" /><br />
Garancija: <asp:TextBox ID="txtGarancija" runat="server" /><br />
Stanje: <asp:TextBox ID="txtStanje" runat="server" /><br />
Opis: <asp:TextBox ID="txtOpis" runat="server" /><br />
Starost (meseci): <asp:TextBox ID="txtStarost" runat="server" /><br /><br />

<asp:Button ID="btnAddOglas" runat="server" Text="Unos Oglasa" OnClick="btnAddOglas_Click" />
<asp:Button ID="btnDeleteOglas" runat="server" Text="Brisanje Oglasa" OnClick="btnDeleteOglas_Click" />
<asp:Button ID="btnUpdateCena" runat="server" Text="Izmena Cene" OnClick="btnUpdateCena_Click" />

<hr />

<!-- ================= SLIKE ================= -->
<h2>Slike</h2>
Slika ID: <asp:TextBox ID="txtSlikaId" runat="server" /><br />
Oglas ID: <asp:TextBox ID="txtSlikaOglasId" runat="server" /><br />
Putanja: <asp:TextBox ID="txtPutanja" runat="server" /><br /><br />

<asp:Button ID="btnAddSlika" runat="server" Text="Unos Slike" OnClick="btnAddSlika_Click" />
<asp:Button ID="btnDeleteSlika" runat="server" Text="Brisanje Slike" OnClick="btnDeleteSlika_Click" />
<asp:Button ID="btnPrikazSlika" runat="server" Text="Prikaz Slika" OnClick="btnPrikazSlika_Click" />

<br /><br />

<asp:GridView ID="gridSlike" runat="server"></asp:GridView>

<hr />

<asp:Label ID="lblResult" runat="server" ForeColor="Red"></asp:Label>

</form>
</body>
</html>