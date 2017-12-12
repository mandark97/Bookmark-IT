using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bookmarks_Show : System.Web.UI.Page
{
    protected void CheckLogged()
    {
        if (User.Identity.GetUserId() == null)
            Response.Redirect("/");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Params["id"] == null)
            Response.Redirect("/");
        CommentsIndex.SelectCommand = String.Format("SELECT comments.id commentId, userId, userName, Text from comments join AspNetUsers on(userId = AspNetUsers.id) where bookmarkid = {0} order by comments.id", Request.Params["id"]);

        int id = int.Parse(Request.Params["id"].ToString());
        string query = "select * from bookmarks where id = @id";

        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        con.Open();
        try
        {
            SqlCommand com = new SqlCommand(query, con);
            com.Parameters.AddWithValue("Id", id);

            SqlDataReader reader = com.ExecuteReader();

            while (reader.Read())
            {
                BookmarkRating.Text = reader["Rating"].ToString();
                BookmarkName.Text = reader["Name"].ToString();
                BookmarkUrl.Text = reader["Url"].ToString();
                BookmarkDescription.Text = reader["Description"].ToString();
                BookmarkImage.ImageUrl = reader["Image"].ToString();
            }
        }
        catch (Exception ex)
        {
            // Answer.Text = "Database select error" + ex.Message;

        }
        finally
        {
            con.Close();
        }
        BookmarkUpdate.NavigateUrl = String.Format("~/Bookmarks/Edit.aspx?id={0}", Request.Params["id"]);
        BookmarkUpdate.Visible = true;

    }


    protected void AddComment_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid || Request.Params["id"] == null)
            Response.Redirect("/");

        string userId = User.Identity.GetUserId();
        string bookmarkId = Request.Params["id"];
        string insertQuery = "insert into Comments(Text, BookmarkId, UserId) values(@text, @bookmarkId, @userId)";


        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        con.Open();
        try
        {
            SqlCommand com = new SqlCommand(insertQuery, con);
            com.Parameters.AddWithValue("Text", CommentText.Text);
            com.Parameters.AddWithValue("BookmarkId", bookmarkId);
            com.Parameters.AddWithValue("userId", userId);

            com.ExecuteNonQuery();
            Answer.Text = "Comment created";
            CommentText.Text = "";
        }
        catch (Exception ex)
        {
            Answer.Text = "Database insert error : " + ex.Message;
        }
        finally
        {
            con.Close();
        }

        Response.Redirect(Request.UrlReferrer.ToString());
    }

    protected void DeleteComment_Click(object sender, ListViewCommandEventArgs e)
    {
        if (Request.Params["id"] == null)
            Response.Redirect("/");
        try
        {
            int id = int.Parse(e.CommandArgument.ToString());

            string deleteQuery = "delete from comments where id = @id";

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            try
            {
                SqlCommand com = new SqlCommand(deleteQuery, con);
                com.Parameters.AddWithValue("Id", id);

                com.ExecuteNonQuery();
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
            Answer.Text = "Database connection error" + ex.Message;
        }
    }
}