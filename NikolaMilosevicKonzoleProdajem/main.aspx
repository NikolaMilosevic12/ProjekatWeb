<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="NikolaMilosevicKonzoleProdajem.main" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="~/css/main.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content_main">
        <div id="filters">
            <asp:Label ID="filterLabel" runat="server" Text="Filteri"></asp:Label>
            <div id="filtersDiv">
                <div class="filterField">
                    <asp:Label runat="server" Text="Cena od"></asp:Label>
                    <asp:TextBox ID="cenaMinBox" runat="server" Width="100px"></asp:TextBox>
                </div>
                <div class="filterField">
                    <asp:Label runat="server" Text="Cena do"></asp:Label>
                    <asp:TextBox ID="cenaMaxBox" runat="server" Width="100px"></asp:TextBox>
                </div>
                <div class="filterField">
                    <asp:Label runat="server" Text="Lokacija"></asp:Label>
                    <asp:DropDownList ID="lokacijaFilterList" runat="server" Height="24px" Width="100px"></asp:DropDownList>
                </div>
                <div class="filterField">
                    <asp:Label runat="server" Text="Stanje"></asp:Label>
                    <asp:DropDownList ID="stanjeFilterList" runat="server" Height="24px" Width="100px"></asp:DropDownList>
                </div>
                <div class="filterField">
                    <asp:Label runat="server" Text="Garancija"></asp:Label>
                    <asp:DropDownList ID="garancijaFilterList" runat="server" Height="24px" Width="100px"></asp:DropDownList>
                </div>
                <div id="primeniButtonDiv">
                    <asp:Button ID="primeniButton" runat="server" Text="Primeni" Height="24px" Width="80px" OnClick="primeniButton_Click" />
                </div>
            </div>
        </div>

        <div id="oglasField">
            <asp:Repeater ID="oglasi" runat="server">
                <ItemTemplate>
                    <a href='oglas_page.aspx?id=<%# Eval("oglas_id") %>' style="text-decoration:none; color:inherit;">
                        <div class="oglas">
                            <div class="leftSide">
                                <h3><%# Eval("naziv") %></h3>
                                <p><%# Eval("korisnik_lokacija") %></p>
                                <p style="color: red;"><%# Eval("cena") %><%# Eval("valuta_simbol") %></p>
                            </div>
                            <div class="rightSide">
                                <p><%# Eval("korisnik_ime") %> (<%# Eval("korisnik_poz_ocene") %>/<%# Eval("korisnik_neg_ocene") %>)</p>
                                <p><%# Eval("timeAgo") %></p>
                            </div>
                        </div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
