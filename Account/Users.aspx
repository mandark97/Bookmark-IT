<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Users.aspx.cs" Inherits="Account_Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:SqlDataSource ID="UsersIndex" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="select AspNetUsers.Id UserId,Email,UserName,Name from AspNetUsers join AspNetUserRoles on(AspNetUsers.Id = AspNetUserRoles.UserId) join AspNetRoles on(AspNetRoles.Id = AspNetUserRoles.RoleId);"></asp:SqlDataSource>
    <asp:Label ID="Answer" runat="server" Text=""></asp:Label>
    <div class="panel panel-primary" runat="server">
        <div class="panel-heading">

            <h3 class="panel-title">Users Management        
            </h3>
        </div>
        <table class="table">
            <thead>
                <tr>
                    <th>Email</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
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
                        <tr>
                            <td><%# Eval("email") %></td>
                            <td><%# Eval("username") %></td>
                            <td><%# Eval("name") %></td>
                            <td>
                                <asp:Button ID="DeleteUser" runat="server" Text="Delete Account" CommandName="delete" CssClass="btn btn-sm btn-danger" CommandArgument='<%# Eval("userid") %>' />
                                <asp:Button ID="PromoteUser" runat="server" Text="Make Admin" CommandName="promote" CssClass="btn btn-sm btn-primary" CommandArgument='<%# Eval("userid") %>' />
                            </td>
                        </tr>

                    </ItemTemplate>
                </asp:ListView>
            </tbody>
        </table>
    </div>
</asp:Content>

