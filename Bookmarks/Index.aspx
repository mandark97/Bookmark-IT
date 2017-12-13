<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Bookmarks_Index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:SqlDataSource ID="BookmarkIndex" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>"></asp:SqlDataSource>
    <div>
        <asp:SqlDataSource ID="PopularTags" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="select top 3 id,name, count(id) popularity from tags join BookmarkTags on TagId= id group by id,name order by popularity desc;"></asp:SqlDataSource>
        <div class="panel panel-default">
            <div class="panel-heading">
                Popular tags:
            </div>
            <ul class="list-group">
                <asp:ListView ID="ListView3" runat="server" DataSourceID="PopularTags">
                    <ItemTemplate>
                        <asp:HyperLink CssClass="list-group-item" ID="HyperLink3" runat="server" NavigateUrl='<%# Eval("name", "~/Bookmarks/Index.aspx?q={0}") %>'>
                <%# Eval("name") %>   Used: <%# Eval("popularity") %>
                        </asp:HyperLink>
                    </ItemTemplate>
                </asp:ListView>
            </ul>
        </div>
    </div>
    <asp:Label ID="Answer" runat="server" Text=""></asp:Label>
    <asp:LoginView runat="server">
        <RoleGroups>
            <asp:RoleGroup Roles="Admin">
                <ContentTemplate>
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
                </ContentTemplate>
            </asp:RoleGroup>
        </RoleGroups>
        <AnonymousTemplate>
            <asp:ListView ID="ListView4" runat="server" DataSourceID="BookmarkIndex" OnItemCommand="Item_Click">
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
                                        <asp:Label ID="Upvote" runat="server" CssClass="btn btn-default btn-lg">
                                            <asp:Label ID="BookmarkRating" runat="server" Text='<%# Eval("Rating") %>'></asp:Label>
                                            <i class="glyphicon glyphicon-triangle-top"></i>
                                        </asp:Label>
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
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:ListView>
        </AnonymousTemplate>
        <LoggedInTemplate>
                                <asp:ListView ID="ListView5" runat="server" DataSourceID="BookmarkIndex" OnItemCommand="Item_Click">
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
                                        <asp:HyperLink ID="Update" runat="server" Visible='<%# Eval("UserId").Equals(User.Identity.GetUserId()) %>' NavigateUrl='<%# Eval("Id","~/Bookmarks/Edit.aspx?id={0}")%>'><i class="glyphicon glyphicon-pencil"></i></asp:HyperLink>
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
                <LayoutTemplate>
        </LoggedInTemplate>
    </asp:LoginView>
</asp:Content>

