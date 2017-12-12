<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Show.aspx.cs" Inherits="Bookmarks_Show" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <div>
        <div class="panel panel-default" runat="server">
            <div>
                <asp:Label ID="BookmarkRating" runat="server" />
                <asp:HyperLink ID="BookmarkUpdate" runat="server" Visible="false">Update Bookmark</asp:HyperLink>
            </div>
            <div class="panel-body">
                <asp:Image ID="BookmarkImage" runat="server" ImageUrl='<%# Eval("image") %>' Height="100px" Width="100px" />
                <asp:Label ID="BookmarkName" runat="server"></asp:Label>
                <asp:Label ID="BookmarkUrl" runat="server"></asp:Label>
                <asp:Label ID="BookmarkDescription" runat="server"></asp:Label>
            </div>
        </div>
    </div>
    <div class="commentForm">
        <asp:Label runat="server" ID="Answer"></asp:Label>
        <asp:ValidationSummary runat="server" CssClass="text-danger" />
        <div class="form-group">
            <asp:TextBox runat="server" ID="CommentText" CssClass="form-control" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="CommentText"
                CssClass="text-danger" ErrorMessage="The comment name field is required." />
        </div>
        <asp:Button ID="AddComment" runat="server" Text="Comment" OnClick="AddComment_Click" />
    </div>
    <asp:SqlDataSource ID="CommentsIndex" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>"></asp:SqlDataSource>
    <asp:ListView ID="ListView1" runat="server" DataSourceID="CommentsIndex" OnItemCommand="DeleteComment_Click">
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
                <asp:Button ID="DeleteComment" runat="server" Visible='<%# Eval("UserId").Equals(User.Identity.GetUserId()) %>' Text="Delete" CausesValidation="false" CommandArgument='<%# Eval("commentId") %>' />
                <asp:Label runat="server" ID="UserName">
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("UserId","~/Bookmarks/Personal.aspx?user={0}")%>'>
                    <%# Eval("username") %>
                    </asp:HyperLink>

                </asp:Label>
                <asp:Label ID="CommentText" runat="server"><%# Eval("Text") %></asp:Label>
            </div>
        </ItemTemplate>
    </asp:ListView>
</asp:Content>

