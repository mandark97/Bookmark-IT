<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Users.aspx.cs" Inherits="Account_Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:SqlDataSource ID="UsersIndex" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="select AspNetUsers.Id UserId,Email,UserName,Name from AspNetUsers join AspNetUserRoles on(AspNetUsers.Id = AspNetUserRoles.UserId) join AspNetRoles on(AspNetRoles.Id = AspNetUserRoles.RoleId);"></asp:SqlDataSource>
    <asp:Label ID="Answer" runat="server" Text=""></asp:Label>
    <asp:ListView ID="ListView1" runat="server" DataSourceID="UsersIndex" OnItemCommand="ListView1_ItemCommand">
        <LayoutTemplate>
            <div id="itemPlaceholder" runat="server"></div>
            <asp:DataPager ID="DataPager1" runat="server" PageSize="10">
                <Fields>
                    <asp:NumericPagerField ButtonType="Button" />
                </Fields>
            </asp:DataPager>
        </LayoutTemplate>
        <ItemTemplate>
            <div class="panel panel-default" runat="server">
                <asp:Label ID="Email" runat="server" Text="Email: "><%# Eval("email") %></asp:Label>
                <asp:Label ID="Username" runat="server" Text="Username: "><%# Eval("username") %></asp:Label>
                <asp:Label ID="Role" runat="server" Text="Role: "><%# Eval("name") %></asp:Label>
                <asp:Button ID="DeleteUser" runat="server" Text="Delete Account" CommandName="delete" CommandArgument='<%# Eval("userid") %>' />
                <asp:Button ID="PromoteUser" runat="server" Text="Make Admin" CommandName="promote" CommandArgument='<%# Eval("userid") %>' />
            </div>

        </ItemTemplate>
    </asp:ListView>
</asp:Content>

