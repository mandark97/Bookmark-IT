using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Providers.Entities;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;
using BookmarkIT;

public partial class Account_Users : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var manager = new UserManager();
        if(!manager.IsInRole(User.Identity.GetUserId(), "Admin"))
        {
            Response.Redirect("/");
        }
    }

    protected void ListView1_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            string userid = e.CommandArgument.ToString();
            string deleteUser = "delete from AspNetUsers where id = @userid";
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();

            try
            {
                SqlCommand com = new SqlCommand(deleteUser, con);
                com.Parameters.AddWithValue("userId", userid);

                com.ExecuteNonQuery();
                Answer.Text = "Account deleted";
            }
            catch (Exception ex)
            {
                Answer.Text = ex.Message;
            }
            finally
            {
                con.Close();
            }

        }
        if (e.CommandName == "promote")
        {
            string userid = e.CommandArgument.ToString();
            var manager = new UserManager();
            try
            {
                var user = manager.FindById(userid);
                manager.RemoveFromRole(user.Id, "RegularUser");
                manager.AddToRole(user.Id, "Admin");
            }
            catch (Exception ex)
            {
                Answer.Text = ex.Message;
            }
        }
        Response.Redirect(Request.UrlReferrer.ToString());
    }
}