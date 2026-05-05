<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="oglas_page.aspx.cs" Inherits="NikolaMilosevicKonzoleProdajem.oglas_page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="~/css/oglas_page.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="oglas_page_wrap">
        <div id="leva_strana">
            <div id="slajder">
                <asp:Button ID="leftBtn" runat="server" Text="&lt;" OnClick="leftBtn_Click" />
                <asp:Image ID="oglasImage" runat="server" Width="400px" Height="300px" />
                <asp:Button ID="rightBtn" runat="server" Text="&gt;" OnClick="rightBtn_Click" />
            </div>
            <asp:Label ID="picNumber" runat="server"></asp:Label>

            <h2><asp:Label ID="titleLabel" runat="server"></asp:Label></h2>
            <p><asp:Label ID="descriptionLabel" runat="server"></asp:Label></p>
            <h3><asp:Label ID="priceLabel" runat="server"></asp:Label></h3>

            <asp:GridView ID="dataGrid" runat="server" AutoGenerateColumns="false" ShowHeader="false">
                <Columns>
                    <asp:BoundField DataField="Naziv" />
                    <asp:BoundField DataField="Vrednost" />
                </Columns>
            </asp:GridView>
        </div>

        <div id="desna_strana">
            <a href='#' runat="server" id="userLink">
                <asp:Label ID="userNameLabel" runat="server"></asp:Label>
            </a>
            <p><asp:Label ID="locationLabel" runat="server"></asp:Label></p>
            <p><asp:Label ID="positiveLabel" runat="server"></asp:Label></p>
            <p><asp:Label ID="negativeLabel" runat="server"></asp:Label></p>
        </div>
    </div>
</asp:Content>
