<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="new_oglas.aspx.cs" Inherits="NikolaMilosevicKonzoleProdajem.new_oglas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="padding:20px;">
        <h2>Novi oglas</h2>

        <div>
            <asp:Label runat="server" Text="Naziv:"></asp:Label>
            <asp:TextBox ID="nameBox" runat="server"></asp:TextBox>
        </div>
        <div>
            <asp:Label runat="server" Text="Opis:"></asp:Label>
            <asp:TextBox ID="descriptionBox" runat="server" TextMode="MultiLine" Rows="4"></asp:TextBox>
        </div>
        <div>
            <asp:Label runat="server" Text="Cena:"></asp:Label>
            <asp:TextBox ID="priceBox" runat="server"></asp:TextBox>
            <asp:DropDownList ID="valutaBox" runat="server"></asp:DropDownList>
        </div>
        <div>
            <asp:Label runat="server" Text="Marka:"></asp:Label>
            <asp:DropDownList ID="markaBox" runat="server" AutoPostBack="true" OnSelectedIndexChanged="markaBox_SelectedIndexChanged"></asp:DropDownList>
        </div>
        <div>
            <asp:Label runat="server" Text="Model:"></asp:Label>
            <asp:DropDownList ID="modelBox" runat="server"></asp:DropDownList>
        </div>
        <div>
            <asp:Label runat="server" Text="Memorija:"></asp:Label>
            <asp:TextBox ID="memorijaBox" runat="server"></asp:TextBox>
        </div>
        <div>
            <asp:Label runat="server" Text="Stanje:"></asp:Label>
            <asp:DropDownList ID="stanjeBox" runat="server"></asp:DropDownList>
        </div>
        <div>
            <asp:Label runat="server" Text="Garancija:"></asp:Label>
            <asp:DropDownList ID="garancijaBox" runat="server"></asp:DropDownList>
        </div>
        <div>
            <asp:Label runat="server" Text="Slike:"></asp:Label>
            <asp:FileUpload ID="fileUpload" runat="server" AllowMultiple="true" />
        </div>
        <div>
            <asp:Button ID="finishButton" runat="server" Text="Postavi oglas" OnClick="finishButton_Click" />
        </div>
        <asp:Label ID="poruka" runat="server" ForeColor="Red"></asp:Label>
    </div>
</asp:Content>
