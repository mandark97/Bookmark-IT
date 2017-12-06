using BookmarkIT;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bookmarks_NewBookmark : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void CreateBookmark_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                string name = BookmarkName.Text;
                string url = BookmarkUrl.Text;
                string description = BookmarkDescription.Text;

                var manager = new UserManager();
                var user = manager.FindById(User.Identity.GetUserId());

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                string insertQuery = "insert into Bookmarks(Name,Url,Description,UserId) values(@name, @url, @description, @userId)";
                try
                {
                    SqlCommand com = new SqlCommand(insertQuery, con);
                    com.Parameters.AddWithValue("name", name);
                    com.Parameters.AddWithValue("url", url);
                    com.Parameters.AddWithValue("description", description);
                    com.Parameters.AddWithValue("userId", user.Id);

                    com.ExecuteNonQuery();
                    Answer.Text = "Bookmark created";
                    BookmarkName.Text = "";
                    BookmarkUrl.Text = "";
                    BookmarkDescription.Text = "";
                    
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
            catch (SqlException se)
            {
                Answer.Text = "Database connexion error : " + se.Message;
            }
            catch (Exception ex)
            {
                Answer.Text = "Error " + ex.Message;
            }
        }
    }
}