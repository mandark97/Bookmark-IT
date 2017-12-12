using BookmarkIT;
using Microsoft.AspNet.Identity;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bookmarks_NewBookmark : System.Web.UI.Page
{
    protected void CheckLogged()
    {
        if (User.Identity.GetUserId() == null)
            Response.Redirect("/");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        CheckLogged();
    }

    protected void CreateBookmark_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            try
            {

                AddBookmark(con);
                AddTags(con);
            }
            catch (Exception ex)
            {
                Answer.Text = "Database insert error : " + ex.Message;
            }
            finally
            {
                con.Close();
            }

        }
    }

    private void AddBookmark(SqlConnection con)
    {
        string name = BookmarkName.Text;
        string url = BookmarkUrl.Text;
        string description = BookmarkDescription.Text;
        string userId = User.Identity.GetUserId();
        string filepath = "";
        if(Image.HasFile)
        {
            string fileName = Path.GetFileName(Image.PostedFile.FileName);
            Image.PostedFile.SaveAs(Server.MapPath("~/Images/") + fileName);
            filepath = "~/Images/" + fileName;
        }

        string insertQuery = "insert into Bookmarks(Name,Url,Description,UserId, Image) values(@name, @url, @description, @userId, @image)";

        SqlCommand com = new SqlCommand(insertQuery, con);
        com.Parameters.AddWithValue("name", name);
        com.Parameters.AddWithValue("url", url);
        com.Parameters.AddWithValue("description", description);
        com.Parameters.AddWithValue("userId", userId);
        com.Parameters.AddWithValue("image", filepath);

        com.ExecuteNonQuery();

    }

    private void AddTags(SqlConnection con)
    {
        ArrayList tags = new ArrayList();
        tags.Add(Tag1);
        tags.Add(Tag2);
        tags.Add(Tag3);

        string addTag = "if not exists (select * from tags where name = @name) " +
                                "insert into Tags(Name) values(@name)";
        string addConnection = "insert into bookmarkTags(TagId, BookmarkId) values((select top 1 id from tags where name = @name), (select top 1 id from bookmarks order by id desc))";

        SqlCommand com;

        foreach (TextBox tag in tags)
        {
            if (tag.Text == null || tag.Text == "")
                continue;
            com = new SqlCommand(addTag, con);
            com.Parameters.AddWithValue("name", tag.Text.ToLower());
            com.ExecuteNonQuery();
            com = new SqlCommand(addConnection, con);
            com.Parameters.AddWithValue("name", tag.Text.ToLower());
            com.ExecuteNonQuery();
        }

        Answer.Text = "Bookmark created";
        BookmarkName.Text = "";
        BookmarkUrl.Text = "";
        BookmarkDescription.Text = "";
        foreach (TextBox tag in tags)
            tag.Text = "";
    }
}