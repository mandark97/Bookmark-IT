<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="New.aspx.cs" Inherits="Bookmarks_NewBookmark" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="form-horizontal">
        <h4>Create new Bookmark.</h4>
        <hr />
        <asp:ValidationSummary runat="server" CssClass="text-danger" />
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="BookmarkName" CssClass="col-md-2 control-label">Name</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="BookmarkName" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="BookmarkName"
                    CssClass="text-danger" ErrorMessage="The bookmark name field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="BookmarkUrl" CssClass="col-md-2 control-label">Url</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="BookmarkUrl" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="BookmarkUrl"
                    CssClass="text-danger" ErrorMessage="The bookmark url field is required." />
            </div>
        </div>

        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="BookmarkDescription" CssClass="col-md-2 control-label">Description</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="BookmarkDescription" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="BookmarkDescription"
                    CssClass="text-danger" ErrorMessage="The bookmark description field is required." />
            </div>
        </div>
        <asp:FileUpload ID="Image" runat="server"/>
        <div class="form-inline">
                <asp:TextBox runat="server" ID="Tag1" CssClass="form-control" />
                <asp:TextBox runat="server" ID="Tag2" CssClass="form-control" />
                <asp:TextBox runat="server" ID="Tag3" CssClass="form-control" />
        </div>
        <div class="form-group">
            <div class="col-md-offset-2 col-md-10">
                <asp:Button runat="server" OnClick="CreateBookmark_Click" Text="Create Bookmark" CssClass="btn btn-default" />
            </div>
        </div>
    </div>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="text-danger"/>
    <asp:Label ID="Answer" runat="server"></asp:Label>
</asp:Content>

