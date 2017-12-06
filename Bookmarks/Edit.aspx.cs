using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bookmarks_Edit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack && Request.Params["id"] != null)
        {
            try
            {
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
                        BookmarkName.Text = reader["Name"].ToString();
                        BookmarkUrl.Text = reader["Url"].ToString();
                        BookmarkDescription.Text = reader["Description"].ToString();
                    }
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
                Answer.Text = "Database connection error" + ex.Message;
            }
        }
    }

    protected void UpdateBookmark_Click(object sender, EventArgs e)
    {
        if( Page.IsValid && Request.Params["id"] != null)
        {
            try
            {
                int id = int.Parse(Request.Params["id"].ToString());
                string name = BookmarkName.Text;
                string url = BookmarkUrl.Text;
                string description = BookmarkDescription.Text;

                string updateQuery = "update Bookmarks set Name = @name, Url = @url, Description = @description where id = @id";

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                try
                {
                    SqlCommand com = new SqlCommand(updateQuery, con);
                    com.Parameters.AddWithValue("name", name);
                    com.Parameters.AddWithValue("url", url);
                    com.Parameters.AddWithValue("description", description);
                    com.Parameters.AddWithValue("Id", id);

                    com.ExecuteNonQuery();
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
}