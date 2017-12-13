<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Personal.aspx.cs" Inherits="Bookmarks_Personal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:SqlDataSource ID="BookmarkIndex" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>"></asp:SqlDataSource>
    <asp:Label ID="Answer" runat="server" Text=""></asp:Label>
    <p class="h3">

            <asp:Label ID="Username" runat="server"></asp:Label>'s favorite posts
    </p>
    <asp:LoginView runat="server">
        <AnonymousTemplate>
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
                    <div class="">
                        <div class="panel panel-default row" runat="server">
                            <div class="col-md-1">
                                <asp:LinkButton ID="Upvote" runat="server" CausesValidation="false" CommandName="Upvote" CommandArgument='<%# Eval("Id") %>' CssClass='<%# Eval("upvote").ToString() == 1.ToString() ? "btn btn-default btn-lg active":"btn btn-default btn-lg"%>'>
                                    <asp:Label ID="BookmarkRating" runat="server" Text='<%# Eval("Rating") %>'></asp:Label>
                                    <i class="glyphicon glyphicon-triangle-top"></i>
                                </asp:LinkButton>
                            </div>
                            <div class="col-md-2">

                                <asp:Image ID="BookmarkImage" CssClass="img-responsive thumbnail" runat="server" ImageUrl='<%# Eval("image").ToString()=="" ? "http://shashgrewal.com/wp-content/uploads/2015/05/default-placeholder-300x300.png": Eval("image") %>' />
                            </div>

                            <div class="panel-body col-md-7">
                                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Eval("Id","~/Bookmarks/Show.aspx?id={0}")%>'>
                                    <asp:Label ID="BookmarkName" runat="server" CssClass="h3">
                                        <strong><%# Eval("Name") %></strong>
                                    </asp:Label>
                                </asp:HyperLink>
                                <asp:HyperLink ID="Update" runat="server" NavigateUrl='<%# Eval("Id","~/Bookmarks/Edit.aspx?id={0}")%>'><i class="glyphicon glyphicon-pencil"></i></asp:HyperLink>
                                <br />
                                <asp:HyperLink ID="BookmarkUrl" runat="server" NavigateUrl='<%# Eval("Url") %>'><%# Eval("URL") %></asp:HyperLink>
                                <br />
                                <asp:Label ID="BookmarkDescription" runat="server"><%# Eval("Description") %></asp:Label>
                                <hr />
                                <asp:ListView ID="ListView2" runat="server" DataSourceID="Tags">
                                    <LayoutTemplate>
                                        Tags:
                                                <div id="itemPlaceholder" runat="server"></div>
                                    </LayoutTemplate>
                                    <ItemTemplate>

                                        <label><%# Eval("name") %></label>
                                    </ItemTemplate>
                                </asp:ListView>
                            </div>
                            <div class="col-md-1">
                                <asp:LinkButton ID="Favorite" runat="server" Text="Favorite" CausesValidation="false" CommandName="Favorite" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-default btn-md">
                                            <i class='<%# Eval("favorite").ToString() == 1.ToString() ? "glyphicon glyphicon-heart":"glyphicon glyphicon-heart-empty"%>'></i>
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </LoggedInTemplate>
    </asp:LoginView>
</asp:Content>

