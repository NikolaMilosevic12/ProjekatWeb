<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="NikolaMilosevicKonzoleProdajem.admin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="padding:20px;">
        <h2>Admin panel</h2>

        <asp:Button ID="logoutButton" runat="server" Text="Logout" OnClick="logoutButton_Click" />

        <hr />
        <h3>Marke</h3>
        <asp:GridView ID="markaGrid" runat="server" AutoGenerateColumns="true"></asp:GridView>
        <asp:TextBox ID="markeBox" runat="server" placeholder="Nova marka"></asp:TextBox>
        <asp:Button ID="markeButton" runat="server" Text="Dodaj" OnClick="markeButton_Click" />
        <asp:DropDownList ID="markaComboBox" runat="server"></asp:DropDownList>
        <asp:Button ID="markaDeleteButton" runat="server" Text="Obrisi" OnClick="markaDeleteButton_Click" />

        <hr />
        <h3>Modeli</h3>
        <asp:GridView ID="modelGrid" runat="server" AutoGenerateColumns="true"></asp:GridView>
        <asp:DropDownList ID="modelMarkaBox" runat="server"></asp:DropDownList>
        <asp:TextBox ID="modelBox" runat="server" placeholder="Novi model"></asp:TextBox>
        <asp:Button ID="modelButton" runat="server" Text="Dodaj" OnClick="modelButton_Click" />
        <asp:DropDownList ID="modelMarkaComboBox" runat="server" AutoPostBack="true" OnSelectedIndexChanged="modelMarkaComboBox_SelectedIndexChanged"></asp:DropDownList>
        <asp:DropDownList ID="modelComboBox" runat="server"></asp:DropDownList>
        <asp:Button ID="modelDeleteButton" runat="server" Text="Obrisi" OnClick="modelDeleteButton_Click" />

        <hr />
        <h3>Lokacije</h3>
        <asp:GridView ID="lokacijaGrid" runat="server" AutoGenerateColumns="true"></asp:GridView>
        <asp:TextBox ID="lokacijaBox" runat="server" placeholder="Nova lokacija"></asp:TextBox>
        <asp:Button ID="lokacijaButton" runat="server" Text="Dodaj" OnClick="lokacijaButton_Click" />
        <asp:DropDownList ID="lokacijaComboBox" runat="server"></asp:DropDownList>
        <asp:Button ID="lokacijaDeleteButton" runat="server" Text="Obrisi" OnClick="lokacijaDeleteButton_Click" />

        <hr />
        <h3>Stanja</h3>
        <asp:GridView ID="stanjeGrid" runat="server" AutoGenerateColumns="true"></asp:GridView>
        <asp:TextBox ID="stanjeBox" runat="server" placeholder="Novo stanje"></asp:TextBox>
        <asp:Button ID="stanjeButton" runat="server" Text="Dodaj" OnClick="stanjeButton_Click" />
        <asp:DropDownList ID="stanjeComboBox" runat="server"></asp:DropDownList>
        <asp:Button ID="stanjeDeleteButton" runat="server" Text="Obrisi" OnClick="stanjeDeleteButton_Click" />

        <hr />
        <h3>Garancije</h3>
        <asp:GridView ID="garancijaGrid" runat="server" AutoGenerateColumns="true"></asp:GridView>
        <asp:TextBox ID="garancijaBox" runat="server" placeholder="Nova garancija"></asp:TextBox>
        <asp:Button ID="garancijaButton" runat="server" Text="Dodaj" OnClick="garancijaButton_Click" />
        <asp:DropDownList ID="garancijaComboBox" runat="server"></asp:DropDownList>
        <asp:Button ID="garancijaDeleteButton" runat="server" Text="Obrisi" OnClick="garancijaDeleteButton_Click" />

        <hr />
        <h3>Valute</h3>
        <asp:GridView ID="valutaGrid" runat="server" AutoGenerateColumns="true"></asp:GridView>
        <asp:TextBox ID="valutaImeBox" runat="server" placeholder="Naziv"></asp:TextBox>
        <asp:TextBox ID="valutaSimbolBox" runat="server" placeholder="Simbol"></asp:TextBox>
        <asp:TextBox ID="valutaKursBox" runat="server" placeholder="Kurs"></asp:TextBox>
        <asp:Button ID="valutaButton" runat="server" Text="Dodaj" OnClick="valutaButton_Click" />
        <asp:DropDownList ID="valutaComboBox" runat="server"></asp:DropDownList>
        <asp:Button ID="valutaDeleteButton" runat="server" Text="Obrisi" OnClick="valutaDeleteButton_Click" />

        <asp:Label ID="poruka" runat="server" ForeColor="Red"></asp:Label>
    </div>
</asp:Content>
