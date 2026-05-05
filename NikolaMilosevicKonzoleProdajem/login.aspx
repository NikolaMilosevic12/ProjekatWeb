<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="NikolaMilosevicKonzoleProdajem.login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="display:flex; justify-content: center;">
        <div style="padding:20px;">
            <h2>Login</h2>
            <div class="field">
                <asp:Label runat="server" Text="Email:"></asp:Label>
                <asp:TextBox ID="mailBox" runat="server"></asp:TextBox>
            </div>
            <div class="field">
                <asp:Label runat="server" Text="Lozinka:"></asp:Label>
                <asp:TextBox ID="passwordBox" runat="server" TextMode="Password"></asp:TextBox>
            </div>
            <div class="buttons">
                <asp:Button ID="loginButton" runat="server" Text="Login" OnClick="loginButton_Click" />
                <asp:HyperLink runat="server" NavigateUrl="~/register.aspx">Registracija</asp:HyperLink>
            </div>
            <asp:Label ID="poruka" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </div>
</asp:Content>
