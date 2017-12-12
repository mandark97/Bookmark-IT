<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Personal.aspx.cs" Inherits="Bookmarks_Personal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:SqlDataSource ID="BookmarkIndex" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>"></asp:SqlDataSource>

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
    <asp:Label ID="Answer" runat="server" Text=""></asp:Label>
    <div>
        <label>Username: <asp:Label ID="Username" runat="server"></asp:Label></label>
    </div>
    <asp:LoginView runat="server">
        <AnonymousTemplate>
            pl?
        </AnonymousTemplate>
        <LoggedInTemplate>
            <asp:ListView ID="ListView1" runat="server" DataSourceID="BookmarkIndex" OnItemCommand="Item_Click">
                <LayoutTemplate>
                    <div id="itemPlaceholder" runat="server"></div>
                    <asp:DataPager ID="DataPager1" runat="server" PageSize="10">
                        <Fields>
                            <asp:NumericPagerField ButtonType="Button" />
                        </Fields>
                    </asp:DataPager>

                </LayoutTemplate>
                <ItemTemplate>
                    <asp:SqlDataSource ID="Tags" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand='<%# Eval("id","SELECT tags.id tagid, name from tags join bookmarktags bt on(tags.id = bt.tagid) where bt.bookmarkid = {0}") %>'></asp:SqlDataSource>

                    <div class="panel panel-default" runat="server">
                        <p>FAVORITE: <%# Eval("favorite") %></p>
                        <p>Upvoted: <%# Eval("upvote") %></p>
                        <div>
                            <asp:Button ID="Upvote" runat="server" Text="Upvote" CausesValidation="false" CommandName="Upvote" CommandArgument='<%# Eval("Id") %>' />
                            <asp:Button ID="Favorite" runat="server" Text="Favorite" CausesValidation="false" CommandName="Favorite" CommandArgument='<%# Eval("Id") %>' />
                            <asp:Label ID="BookmarkRating" runat="server" Text='<%# Eval("Rating") %>'></asp:Label>
                            <asp:HyperLink ID="Update" runat="server" Visible='<%# Eval("UserId").Equals(User.Identity.GetUserId()) %>' NavigateUrl='<%# Eval("Id","~/Bookmarks/Edit.aspx?id={0}")%>'>Update Bookmark</asp:HyperLink>
                        </div>
                        <div class="panel-body">
                            <asp:Image ID="BookmarkImage" runat="server" ImageUrl='<%# Eval("image") %>' Height="100px" Width="100px" />
                            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Eval("Id","~/Bookmarks/Show.aspx?id={0}")%>'>
                                <asp:Label ID="BookmarkName" runat="server"><%# Eval("Name") %></asp:Label>
                            </asp:HyperLink>
                            <asp:Label ID="BookmarkUrl" runat="server"><%# Eval("URL") %></asp:Label>
                            <asp:Label ID="BookmarkDescription" runat="server"><%# Eval("Description") %></asp:Label>
                            TAGS: 
                    <asp:ListView ID="ListView2" runat="server" DataSourceID="Tags">
                        <ItemTemplate>
                            <p><%# Eval("name") %></p>
                        </ItemTemplate>
                    </asp:ListView>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </LoggedInTemplate>
    </asp:LoginView>
</asp:Content>

