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
        string query = String.Format("SELECT id, name, url, description, rating, userId, image,(select count(*) from BookmarkUsers where BookmarkId = Bookmarks.id and UserId = '{0}') favorite, (select count(*) from Upvotes where BookmarkId = Bookmarks.id and UserId = '{0}') upvote from bookmarks where id = @id", User.Identity.GetUserId());

        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        con.Open();
        try
        {
            SqlCommand com = new SqlCommand(query, con);
            com.Parameters.AddWithValue("Id", id);

            SqlDataReader reader = com.ExecuteReader();

            while (reader.Read())
            {
                Upvote.CommandArgument = id.ToString();
                Upvote.CssClass = reader["upvote"].ToString() == 1.ToString() ? "btn btn-default btn-lg active" : "btn btn-default btn-lg";

                Favorite.CommandArgument = id.ToString();
                glyph.Attributes["class"] = reader["favorite"].ToString() == 1.ToString() ? "glyphicon glyphicon-heart" : "glyphicon glyphicon-heart-empty";

                BookmarkRating.Text = reader["Rating"].ToString();
                BookmarkName.Text = reader["Name"].ToString();
                BookmarkUrl.Text = reader["Url"].ToString();
                BookmarkUrl.NavigateUrl = reader["Url"].ToString();
                BookmarkDescription.Text = reader["Description"].ToString();
                if (reader["Image"].ToString() == "")
                    BookmarkImage.ImageUrl = "http://shashgrewal.com/wp-content/uploads/2015/05/default-placeholder-300x300.png";
                else
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
        if (!User.Identity.IsAuthenticated)
            Response.Redirect(Request.UrlReferrer.ToString());
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

    protected void Upvote_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        con.Open();
        string id = Upvote.CommandArgument;
        string checkUpvote = "select count(*) upvotes from upvotes where userid = @userId and bookmarkid = @bookmarkId";

        string updateQuery = "update bookmarks set rating = rating + 1 where id = @id";
        try
        {
            SqlCommand com = new SqlCommand(checkUpvote, con);
            com.Parameters.AddWithValue("userId", User.Identity.GetUserId());
            com.Parameters.AddWithValue("bookmarkId", id);

            SqlDataReader reader = com.ExecuteReader();
            int upvoteCount = 0;
            while (reader.Read())
            {
                upvoteCount = int.Parse(reader["upvotes"].ToString());
            }
            reader.Close();
            if (upvoteCount == 0)
            {
                string addUpvote = "insert into upvotes(UserId, BookmarkId) values (@userId, @bookmarkId)";
                com = new SqlCommand(addUpvote, con);
                com.Parameters.AddWithValue("userId", User.Identity.GetUserId());
                com.Parameters.AddWithValue("bookmarkId", id);
                com.ExecuteNonQuery();

                com = new SqlCommand(updateQuery, con);
            }
            else
            {
                string deleteUpvote = "delete from upvotes where userId = @userId and bookmarkId = @bookmarkId";
                com = new SqlCommand(deleteUpvote, con);
                com.Parameters.AddWithValue("userId", User.Identity.GetUserId());
                com.Parameters.AddWithValue("bookmarkId", id);
                com.ExecuteNonQuery();
                com = new SqlCommand("update bookmarks set rating = rating - 1 where id = @id", con);
            }
            com.Parameters.AddWithValue("id", id);
            com.ExecuteNonQuery();

            string selectRatingQuery = "select rating from bookmarks where id = @id";

            com = new SqlCommand(selectRatingQuery, con);
            com.Parameters.AddWithValue("id", id);

            reader = com.ExecuteReader();

            while (reader.Read())
            {
                BookmarkRating.Text = reader["Rating"].ToString();
            }
            reader.Close();
            Response.Redirect(Request.UrlReferrer.ToString());

        }
        catch (Exception ex)
        {
            Answer.Text = "asd   " + ex;
        }
        finally
        {
            con.Close();
        }
    }

    protected void Favorite_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        con.Open();
        string id = Favorite.CommandArgument;

        string checkFavorite = "select count(*) favorite from bookmarkusers where userid = @userId and bookmarkId = @bookmarkId";
        try
        {
            SqlCommand com = new SqlCommand(checkFavorite, con);
            com.Parameters.AddWithValue("userId", User.Identity.GetUserId());
            com.Parameters.AddWithValue("bookmarkId", id);

            SqlDataReader reader = com.ExecuteReader();
            int favoriteCheck = 0;
            while (reader.Read())
            {
                favoriteCheck = int.Parse(reader["favorite"].ToString());
            }
            reader.Close();
            if (favoriteCheck == 0)
            {
                string addFavorite = "insert into bookmarkUsers(UserId, BookmarkId) values (@userId, @bookmarkId)";
                com = new SqlCommand(addFavorite, con);
                com.Parameters.AddWithValue("userId", User.Identity.GetUserId());
                com.Parameters.AddWithValue("bookmarkId", id);
                com.ExecuteNonQuery();

            }
            else
            {
                string deleteFavorite = "delete from bookmarkUsers where userId = @userId and bookmarkId = @bookmarkId";
                com = new SqlCommand(deleteFavorite, con);
                com.Parameters.AddWithValue("userId", User.Identity.GetUserId());
                com.Parameters.AddWithValue("bookmarkId", id);
                com.ExecuteNonQuery();
            }
            Response.Redirect(Request.UrlReferrer.ToString());

        }
        catch (Exception ex)
        {
            Answer.Text = "asd   " + ex;
        }
        finally
        {
            con.Close();
        }
    }
}