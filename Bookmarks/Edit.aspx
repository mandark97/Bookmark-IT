<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Bookmarks_Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="form-horizontal">
        <h3 class="text-center">Edit Bookmark.</h3>
        <hr />
        <div class="form-group">
            <asp:ValidationSummary runat="server" CssClass="alert alert-danger" />
            <asp:Label ID="Answer" runat="server" CssClass="alert alert-info" Visible="false"></asp:Label>
        </div>
        <div class="col-md-2">
            <asp:Image ID="BookmarkImage" runat="server" CssClass="img-responsive" Height="200px" Width="200px" />
        </div>
        <div class="col-md-6">

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
                    <asp:CustomValidator ControlToValidate="BookmarkUrl" CssClass="text-danger" runat="server" ErrorMessage="Invalid Url" OnServerValidate="Unnamed_ServerValidate"></asp:CustomValidator>
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
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Image" CssClass="col-md-2 control-label">Image</asp:Label>
                <div class="col-md-10">

                    <asp:FileUpload ID="Image" runat="server" CssClass="form-control" />
                </div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Tag1" CssClass="col-md-2 control-label">Tags</asp:Label>
                <div class="col-md-10">
                    <asp:TextBox runat="server" ID="Tag1" CssClass="form-control" />
                    <asp:TextBox runat="server" ID="Tag2" CssClass="form-control" />
                    <asp:TextBox runat="server" ID="Tag3" CssClass="form-control" />
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-offset-2 col-md-10">
                    <asp:Button runat="server" OnClick="UpdateBookmark_Click" Text="Update Bookmark" CssClass="btn btn-primary" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

