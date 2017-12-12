using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bookmarks_Index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string defaultSelect = String.Format("SELECT id, name, url, description, rating, userId, image,(select count(*) from BookmarkUsers where BookmarkId = Bookmarks.id and UserId = '{0}') favorite, (select count(*) from Upvotes where BookmarkId = Bookmarks.id and UserId = '{0}') upvote from bookmarks ", User.Identity.GetUserId());
        BookmarkIndex.SelectCommand = defaultSelect + "order by id desc;";
        if (!Page.IsPostBack && Request.Params["q"] != null)
        {
            BookmarkIndex.SelectCommand = String.Format("SELECT id, name, url, description, rating, userId, image,(select count(*) from BookmarkUsers where BookmarkId = Bookmarks.id and UserId = '{0}') favorite, (select count(*) from Upvotes where BookmarkId = Bookmarks.id and UserId = '{0}') upvote " +
                "from bookmarks " +
                "where name like '%{1}%' or description like '%{1}%' " +
                "or exists (select * from tags join bookmarktags on(tagid = id) where name like '%{1}%')", User.Identity.GetUserId(), Request.Params["q"]);
        }
        if (!Page.IsPostBack && Request.Params["rating"] != null)
        {
            if (Request.Params["rating"] == "true")
                BookmarkIndex.SelectCommand = defaultSelect + "order by rating desc";
        }



    }


    protected void Item_Click(object sender, ListViewCommandEventArgs e)
    {
        ListViewDataItem dataItem = (ListViewDataItem)e.Item;
        string id = e.CommandArgument.ToString();
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        con.Open();

        if (e.CommandName == "Upvote")
            Upvote(dataItem, id, con);
        else if (e.CommandName == "Favorite")
            Favorite(dataItem, id, con);

        Response.Redirect(Request.UrlReferrer.ToString());
    }
    private void Favorite(ListViewDataItem dataItem, string id, SqlConnection con)
    {
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

    private void Upvote(ListViewDataItem dataItem, string id, SqlConnection con)
    {
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
                Label label = (Label)dataItem.FindControl("BookmarkRating");
                label.Text = reader["Rating"].ToString();
            }
            reader.Close();
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
