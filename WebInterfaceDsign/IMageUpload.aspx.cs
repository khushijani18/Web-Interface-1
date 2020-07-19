using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.IO;

namespace WebInterfaceDsign
{
    public partial class IMageUpload : System.Web.UI.Page
    {
        private string folder_path = "~/Resources/Images/";
        protected void Page_Load(object sender, EventArgs e)
        {
            label_box.Visible = false;


        }
        protected void btn_save_Click(object sender, EventArgs e)
        {
            foreach (HttpPostedFile p in FileUpload1.PostedFiles)
            {
                p.SaveAs(MapPath(folder_path + p.FileName));
                string mainconn = ConfigurationManager.ConnectionStrings["Images"].ConnectionString;
                SqlConnection sqlconn = new SqlConnection(mainconn);
                sqlconn.Open();
                string sqlquery = " insert into [dbo].[ImageSave] ([ImgName],[ImgPath]) values (@ImgName,@ImgPath)";
                SqlCommand sqlcomm = new SqlCommand(sqlquery, sqlconn);
                sqlcomm.Parameters.AddWithValue("@ImgName", p.FileName);
                sqlcomm.Parameters.AddWithValue("@ImgPath", "Resources/Images/" + p.FileName);
                sqlcomm.ExecuteNonQuery();

            }

            label_box.Visible = true;
            Upload_Status.ForeColor = System.Drawing.Color.Green;
            Upload_Status.Text = FileUpload1.PostedFiles.Count + " File Uploaded Successfully ......\n";

            show_data();
        }

        private void show_data()
        {
            DirectoryInfo d = new DirectoryInfo(MapPath(folder_path));
            FileInfo[] f = d.GetFiles();
            Repeater1.DataSource = f;
            Repeater1.DataBind();
        }
       

    }
}