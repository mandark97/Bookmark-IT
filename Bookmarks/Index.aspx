<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Bookmarks_Index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:SqlDataSource ID="BookmarkIndex" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT id,
        name, url, description, rating, userId from bookmarks"></asp:SqlDataSource>
    <asp:LoginView runat="server">
        <AnonymousTemplate>
            <h3>Login to add your own bookmarks!</h3>
        </AnonymousTemplate>
        <LoggedInTemplate>
            <h3>
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Bookmarks/New.aspx">Add new Bookmark<i class="glyphicon glyphicon-plus"></i></asp:HyperLink>
            </h3>
        </LoggedInTemplate>
    </asp:LoginView>
    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
    <asp:ListView ID="ListView1" runat="server" DataSourceID="BookmarkIndex" OnItemCommand="Upvote_Click">
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
                <div>
                    <asp:Label ID="Rating" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Rating") %>'></asp:Label>
                    <asp:HyperLink ID="Update" runat="server" Visible='<%# Eval("UserId").Equals(User.Identity.GetUserId()) %>' NavigateUrl='<%# Eval("Id","~/Bookmarks/Edit.aspx?id={0}")%>'>Update Bookmark</asp:HyperLink>
                </div>
                <div class="panel-body">
                    <p><%# DataBinder.Eval(Container.DataItem, "Name") %></p>
                    <p><%# DataBinder.Eval(Container.DataItem, "URL") %></p>
                    <p><%# DataBinder.Eval(Container.DataItem, "Description") %></p>
                </div>
            </div>
        </ItemTemplate>
    </asp:ListView>
    <%--                <asp:LoginView runat="server">
                    <LoggedInTemplate>
                        <asp:LinkButton ID="Upvote" runat="server" Text="Upvote" CommandName="Upvote" CommandArgument='<%# Eval("Id")%>' />
                    </LoggedInTemplate>
                </asp:LoginView>--%>
</asp:Content>

