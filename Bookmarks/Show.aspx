<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Show.aspx.cs" Inherits="Bookmarks_Show" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <div>
        <div class="panel panel-default row" runat="server">
            <div class="col-md-1">
                <asp:LinkButton ID="Upvote" OnClick="Upvote_Click" runat="server" CausesValidation="false" CommandName="Upvote">
                    <asp:Label ID="BookmarkRating" runat="server"></asp:Label>
                    <i class="glyphicon glyphicon-triangle-top"></i>
                </asp:LinkButton>
            </div>
            <div class="col-md-2">

                <asp:Image ID="BookmarkImage" CssClass="img-responsive thumbnail" runat="server" />
            </div>
            <div class="panel-body col-md-7">
                <strong>
                    <asp:Label ID="BookmarkName" runat="server" CssClass="h3"></asp:Label>
                </strong>
                <asp:HyperLink ID="BookmarkUpdate" runat="server"><i class="glyphicon glyphicon-pencil"></i></asp:HyperLink>
                <br />
                <asp:HyperLink ID="BookmarkUrl" runat="server"></asp:HyperLink>
                <br />
                <asp:Label ID="BookmarkDescription" runat="server"></asp:Label>
            </div>
            <div class="col-md-1">
                <asp:LinkButton ID="Favorite" OnClick="Favorite_Click" runat="server" Text="Favorite" CausesValidation="false" CommandName="Favorite" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-default btn-md">
                    <i id="glyph" runat="server"></i>
                </asp:LinkButton>
            </div>
        </div>
    </div>
    <div class="panel panel-default">
        <asp:Label runat="server" ID="Answer"></asp:Label>
        <asp:ValidationSummary runat="server" CssClass="text-danger" />
        <div class="panel-body">
            <div class="form-inline">
                <asp:TextBox runat="server" ID="CommentText" CssClass="form-control" />
                <asp:Button ID="AddComment" runat="server" Text="Comment" CssClass="btn btn-primary" OnClick="AddComment_Click" />
            </div>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="CommentText" CssClass="text-danger" ErrorMessage="The comment name field is required." />
        </div>

        <asp:SqlDataSource ID="CommentsIndex" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>"></asp:SqlDataSource>
        <ul class="list-group">
            <asp:ListView ID="ListView1" runat="server" DataSourceID="CommentsIndex" OnItemCommand="DeleteComment_Click">
                <LayoutTemplate>

                    <div id="itemPlaceholder" class="list-group-item" runat="server"></div>
                    <asp:DataPager ID="DataPager1" runat="server" PageSize="10">
                        <Fields>
                            <asp:NumericPagerField ButtonType="Button" />
                        </Fields>
                    </asp:DataPager>
                </LayoutTemplate>
                <ItemTemplate>
                    <div class="list-group-item" runat="server">
                        <asp:LinkButton ID="DeleteComment" runat="server" CssClass="btn btn-sm btn-danger pull-right" Visible='<%# Eval("UserId").Equals(User.Identity.GetUserId()) || Roles.IsUserInRole(User.Identity.GetUserName(), "Admin") %>' CausesValidation="false" CommandArgument='<%# Eval("commentId") %>'><i class="glyphicon glyphicon-trash"></i></asp:LinkButton>
                        <asp:Label runat="server" ID="UserName">
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("UserId","~/Bookmarks/Personal.aspx?user={0}")%>'>
                    <%# Eval("username") %>:
                            </asp:HyperLink>
                        </asp:Label>
                        <asp:Label ID="CommentText" runat="server"><%# Eval("Text") %></asp:Label>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </ul>
    </div>

</asp:Content>

