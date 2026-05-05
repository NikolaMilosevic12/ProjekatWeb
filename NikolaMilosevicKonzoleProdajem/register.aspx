<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="NikolaMilosevicKonzoleProdajem.register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="display:flex; justify-content:center;">
        <div style="padding:20px;">
            <h2>Registracija</h2>
            <div class="field">
                <asp:Label runat="server" Text="Ime:"></asp:Label>
                <asp:TextBox ID="nameBox" runat="server"></asp:TextBox>
            </div>
            <div class="field">
                <asp:Label runat="server" Text="Email:"></asp:Label>
                <asp:TextBox ID="mailBox" runat="server"></asp:TextBox>
            </div>
            <div class="field">
                <asp:Label runat="server" Text="Lozinka:"></asp:Label>
                <asp:TextBox ID="passwordBox" runat="server" TextMode="Password"></asp:TextBox>
            </div>
            <div class="field">
                <asp:Label runat="server" Text="Telefon:"></asp:Label>
                <asp:TextBox ID="phoneBox" runat="server"></asp:TextBox>
            </div>
            <div class="field">
                <asp:Label runat="server" Text="Racun:"></asp:Label>
                <asp:TextBox ID="racunBox" runat="server"></asp:TextBox>
            </div>
            <div class="field">
                <asp:Label runat="server" Text="Lokacija:"></asp:Label>
                <asp:DropDownList ID="locationBox" runat="server"></asp:DropDownList>
            </div>
            <div class="buttons">
                <asp:Button ID="registrationButton" runat="server" Text="Registruj se" OnClick="registrationButton_Click" />
                <asp:HyperLink runat="server" NavigateUrl="~/login.aspx">Login</asp:HyperLink>
            </div>
            <asp:Label ID="poruka" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </div>
</asp:Content>
