using Microsoft.AspNet.Identity;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bookmarks_Edit : System.Web.UI.Page
{
    protected void CheckLogged()
    {
        if (User.Identity.GetUserId() == null)
            Response.Redirect("/");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        CheckLogged();
        if (!Page.IsPostBack && Request.Params["id"] != null)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();

            GetData(con);
        }
    }


    protected void UpdateBookmark_Click(object sender, EventArgs e)
    {
        if (Page.IsValid && Request.Params["id"] != null)
        {
            try
            {
                int id = int.Parse(Request.Params["id"].ToString());

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                try
                {
                    UpdateBookmark(id, con);

                    DeleteTags(id, con);
                    AddTags(id, con);

                    Response.Redirect(Request.UrlReferrer.ToString());

                }
                catch (Exception ex)
                {
                    Answer.Text = "Database update error" + ex.Message;

                }
                finally
                {
                    con.Close();
                }

            }
            catch (Exception ex)
            {
                Answer.Text = ex.Message;
            }
        }
    }

    protected void Delete_Click(object sender, EventArgs e)
    {
        if (Page.IsValid && Request.Params["id"] != null)
        {
            try
            {
                int id = int.Parse(Request.Params["id"].ToString());


                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                try
                {
                    DeleteBookmark(id, con);

                    Response.Redirect("/");
                }
                catch (Exception ex)
                {
                    Answer.Text = "Database update error" + ex.Message;

                }
                finally
                {
                    con.Close();
                }

            }
            catch (Exception ex)
            {
                Answer.Text = "Database connection error" + ex.Message;
            }
        }
    }
    private void GetData(SqlConnection con)
    {
        try
        {
            int id = int.Parse(Request.Params["id"].ToString());

            string query = "select * from bookmarks where id = @id";
            string getTags = "SELECT tags.id tagid, name from tags join bookmarktags bt on (tags.id = bt.tagid) where bt.bookmarkid = @id";
            try
            {
                SqlCommand com = new SqlCommand(query, con);
                com.Parameters.AddWithValue("Id", id);

                SqlDataReader reader = com.ExecuteReader();

                while (reader.Read())
                {
                    BookmarkName.Text = reader["Name"].ToString();
                    BookmarkUrl.Text = reader["Url"].ToString();
                    BookmarkDescription.Text = reader["Description"].ToString();
                    BookmarkImage.ImageUrl = reader["Image"].ToString();
                }
                reader.Close();
                com = new SqlCommand(getTags, con);
                com.Parameters.AddWithValue("Id", id);

                reader = com.ExecuteReader();

                if (reader.Read())
                    Tag1.Text = reader["Name"].ToString();
                if (reader.Read())
                    Tag2.Text = reader["Name"].ToString();
                if (reader.Read())
                    Tag3.Text = reader["Name"].ToString();
            }
            catch (Exception ex)
            {
                Answer.Text = "Database select error" + ex.Message;

            }
            finally
            {
                con.Close();
            }
        }
        catch (Exception ex)
        {
            Answer.Text = ex.Message;
        }
    }
    private void UpdateBookmark(int id, SqlConnection con)
    {
        string name = BookmarkName.Text;
        string url = BookmarkUrl.Text;
        string description = BookmarkDescription.Text;
        string filepath = "";
        if (Image.HasFile)
        {
            string fileName = Path.GetFileName(Image.PostedFile.FileName);
            Image.PostedFile.SaveAs(Server.MapPath("~/Images/") + fileName);
            filepath = "~/Images/" + fileName;
        }

        string updateQuery = "update Bookmarks set Name = @name, Url = @url, Description = @description, Image = @image where id = @id";
        SqlCommand com = new SqlCommand(updateQuery, con);
        com.Parameters.AddWithValue("name", name);
        com.Parameters.AddWithValue("url", url);
        com.Parameters.AddWithValue("description", description);
        com.Parameters.AddWithValue("Id", id);
        com.Parameters.AddWithValue("image", filepath);

        com.ExecuteNonQuery();
    }

    private void AddTags(int id, SqlConnection con)
    {
        ArrayList tags = new ArrayList();
        tags.Add(Tag1);
        tags.Add(Tag2);
        tags.Add(Tag3);

        string addTag = "if not exists (select * from tags where name = @name) " +
                                "insert into Tags(Name) values(@name)";
        string addConnection = "insert into bookmarkTags(TagId, BookmarkId) values((select top 1 id from tags where name = @name), @id)";

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
            com.Parameters.AddWithValue("id", id);
            com.ExecuteNonQuery();
        }

        Answer.Text = "Bookmark created";
        BookmarkName.Text = "";
        BookmarkUrl.Text = "";
        BookmarkDescription.Text = "";
        foreach (TextBox tag in tags)
            tag.Text = "";
    }
    private static void DeleteTags(int id, SqlConnection con)
    {
        SqlCommand com;
        string deleteTags = "delete from bookmarktags where bookmarkid = @bookmarkid";
        com = new SqlCommand(deleteTags, con);
        com.Parameters.AddWithValue("bookmarkid", id);

        com.ExecuteNonQuery();
    }


    private static void DeleteBookmark(int id, SqlConnection con)
    {
        string deleteQuery = "delete from bookmarks where id = @id";
        SqlCommand com = new SqlCommand(deleteQuery, con);
        com.Parameters.AddWithValue("Id", id);

        com.ExecuteNonQuery();
    }
}