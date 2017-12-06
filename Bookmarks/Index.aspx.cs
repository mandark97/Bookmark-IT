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
    }

    protected void Upvote_Click(object sender, ListViewCommandEventArgs e)
    {

        if (e.CommandName == "Upvote")
        {
            ListViewDataItem dataItem = (ListViewDataItem)e.Item;
            string id = e.CommandArgument.ToString();
            string updateQuery = "update bookmarks set rating = rating + 1 where id = @id";
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            try
            {
                SqlCommand com = new SqlCommand(updateQuery, con);
                com.Parameters.AddWithValue("id", id);

                com.ExecuteNonQuery();

                string selectRatingQuery = "select rating from bookmarks where id = @id";

                com = new SqlCommand(selectRatingQuery, con);
                com.Parameters.AddWithValue("id", id);

                SqlDataReader reader = com.ExecuteReader();

                while (reader.Read())
                {
                    Label label = (Label)dataItem.FindControl("Rating");
                    label.Text = reader["Rating"].ToString();
                }
            }
            catch (Exception ex)
            {
                Label1.Text = "asd   " + ex;
            }
            finally
            {
                con.Close();
            }
        }
    }
}