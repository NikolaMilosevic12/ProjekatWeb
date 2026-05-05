<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="user_page.aspx.cs" Inherits="NikolaMilosevicKonzoleProdajem.user_page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="userPanel">
        <div style="padding:20px;">
            <h2><asp:Label ID="nameLabel" runat="server"></asp:Label></h2>
            <p>Email: <asp:Label ID="emailLabel" runat="server"></asp:Label></p>
            <p>Telefon: <asp:Label ID="telefonLabel" runat="server"></asp:Label></p>
            <p>Racun: <asp:Label ID="racunLabel" runat="server"></asp:Label></p>
            <p>Lokacija: <asp:Label ID="locationLabel" runat="server"></asp:Label></p>
            <p>Ocene: <asp:Label ID="pozLabel" runat="server"></asp:Label> / <asp:Label ID="negLabel" runat="server"></asp:Label></p>

            <asp:Panel ID="mojaStrana" runat="server" Visible="false">
                <hr />
                <h3>Novi oglas</h3>
                <asp:HyperLink ID="newOglasLink" runat="server" NavigateUrl="~/new_oglas.aspx">Postavi novi oglas</asp:HyperLink>

                <hr />
                <h3>Izmena cene oglasa</h3>
                <asp:DropDownList ID="changeOglasBox" runat="server"></asp:DropDownList>
                <asp:TextBox ID="priceBox" runat="server" placeholder="Nova cena"></asp:TextBox>
                <asp:DropDownList ID="valutaBox" runat="server"></asp:DropDownList>
                <asp:Button ID="changeButton" runat="server" Text="Izmeni cenu" OnClick="changeButton_Click" />

                <hr />
                <h3>Brisanje oglasa</h3>
                <asp:DropDownList ID="deleteBox" runat="server"></asp:DropDownList>
                <asp:Button ID="deleteButton" runat="server" Text="Obrisi oglas" OnClick="deleteButton_Click" />

                <hr />
                <asp:Button ID="logoutButton" runat="server" Text="Logout" OnClick="logoutButton_Click" />
            </asp:Panel>

            <asp:Label ID="poruka" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </div>
</asp:Content>
