using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

namespace WebInterfaceDsign
{
    public class AnnotationArea
    {
        public int dataId { get; set; }
        public int id { get; set; }
        public Double x { get; set; }
        public Double y { get; set; }
        public Double width { get; set; }
        public Double height { get; set; }
        public string tag { get; set; }
        public int visibility { get; set; }
        public int z { get; set; }
    }

    public partial class WebForm2 : System.Web.UI.Page
    {
        private static DataTable mainDt = new DataTable();
        private static int totalImages = 0;
        private static int currentImage = 0;
        private static int currentImageId = 0;
        private static List<AnnotationArea> InnitialAreas = new List<AnnotationArea>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["update"] = Server.UrlEncode(System.DateTime.Now.ToString());
                
                string conString = ConfigurationManager.ConnectionStrings["Images"].ConnectionString;
                SqlConnection con = new SqlConnection(conString);
                string query = "SELECT [ImgId],[ImgName],[ImgPath] FROM [dbo].[ImageSave]";

                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                sda.Fill(mainDt);
                totalImages = mainDt.Rows.Count;
            }

            
            ImageToProcess.ImageUrl = mainDt.Rows[currentImage].ItemArray[2].ToString();
            currentImageId = int.Parse(mainDt.Rows[currentImage].ItemArray[0].ToString()); 
            GetImageAreas(currentImage);
        }

        protected override void OnPreRender(EventArgs e)
        {
            ViewState["update"] = Session["update"];
        }

        //To get Image Areas Coordinates from database and send them to Front End to Display on Image
        protected void GetImageAreas(int currentImage)
        {
            int ImgId = int.Parse(mainDt.Rows[currentImage].ItemArray[0].ToString());
            currentImageId = ImgId;
            InnitialAreas.Clear();

            string conString = ConfigurationManager.ConnectionStrings["Images"].ConnectionString;
            SqlConnection con = new SqlConnection(conString);
            string query = "SELECT [Id],[AreaId],[X],[Y],[Width],[Height],[Label] FROM [dbo].[Coordinates] WHERE ImgId = @Id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.Add("@Id", System.Data.SqlDbType.Int);
            cmd.Parameters["@Id"].Value = ImgId;
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);

         for (int i = 0; i < dt.Rows.Count; i++)
            {
                
                AnnotationArea Area = new AnnotationArea();
                Area.id = int.Parse(dt.Rows[i]["AreaId"].ToString());
                Area.x = int.Parse(dt.Rows[i]["X"].ToString());
                Area.y = int.Parse(dt.Rows[i]["Y"].ToString());
                Area.width = int.Parse(dt.Rows[i]["Width"].ToString());
                Area.height = int.Parse(dt.Rows[i]["Height"].ToString());
                Area.tag = dt.Rows[i]["Label"].ToString();
                Area.dataId = int.Parse(dt.Rows[i]["Id"].ToString());
                InnitialAreas.Add(Area);
            }

            string dataString = "";

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dataString += '~';
                dataString += InnitialAreas[i].id.ToString() + ',' + InnitialAreas[i].x.ToString() + ',' + InnitialAreas[i].y.ToString() + ',' + InnitialAreas[i].width.ToString() + ',' + InnitialAreas[i].height.ToString() + ',' + InnitialAreas[i].tag.ToString();
            }

            if (dataString.Length > 0)
            {
                dataString = dataString.Substring(1);
            }
            ImageAreas.Value = dataString;
        }

        protected void PreviousImage_Click(object sender, EventArgs e)
        {
            if (Session["update"].ToString() == ViewState["update"].ToString())
            {


                if (currentImage > 0)
                {
                    currentImage--;

                    ImageToProcess.ImageUrl = mainDt.Rows[currentImage].ItemArray[2].ToString();
                    currentImageId = int.Parse(mainDt.Rows[currentImage].ItemArray[0].ToString());
                    GetImageAreas(currentImage);
                }

                Session["update"] = Server.UrlEncode(System.DateTime.Now.ToString());
            }
        }

        protected void NextImage_Click(object sender, EventArgs e)
        {
            if (Session["update"].ToString() == ViewState["update"].ToString())
            {
           

                if (currentImage < totalImages - 1)
                {
                    currentImage++;

                    ImageToProcess.ImageUrl = mainDt.Rows[currentImage].ItemArray[2].ToString();
                    currentImageId = int.Parse(mainDt.Rows[currentImage].ItemArray[0].ToString());
                    GetImageAreas(currentImage);
                }

                Session["update"] = Server.UrlEncode(System.DateTime.Now.ToString());
            }

        }

        protected void UploadData_Click(object sender, EventArgs e)
        {
            if (Session["update"].ToString() == ViewState["update"].ToString())
            {
                string areas = ImageJsonData.Value;
                //string deletedAreas = DeletedAreas.Value;
                //string changedAreas = ChangedAreas.Value;
                //string createdAreas = CreatedAreas.Value;

                JavaScriptSerializer json = new JavaScriptSerializer();
                List<AnnotationArea> AreaList = json.Deserialize<List<AnnotationArea>>(areas);
                //List<int> DeletedAreaList = json.Deserialize<List<int>>(deletedAreas);
                //List<int> CreatedAreaList = json.Deserialize<List<int>>(createdAreas);
                //List<int> ChangedAreaList = json.Deserialize<List<int>>(changedAreas);



                string conString = ConfigurationManager.ConnectionStrings["Images"].ConnectionString;
                SqlConnection con = new SqlConnection(conString);
                con.Open();

                //if (AllDeleted.Value == "true")
                //{
                //    foreach (AnnotationArea Area in AreaList)
                //    {
                //        AddNewData(Area, con);
                //    }

                //    for (int i = 0; i < InnitialAreas.Count; i++)
                //    {
                //        DeleteData(InnitialAreas[i].dataId, con);
                //    }

                //    InnitialAreas.Clear();
                //}
                //else
                //{
                //    foreach (int id in DeletedAreaList)
                //    {
                //        ChangedAreaList.RemoveAll(i => i == id);
                //        CreatedAreaList.Remove(id);
                //        foreach (AnnotationArea Area in InnitialAreas)
                //        {
                //            if(Area.id == id)
                //            {
                //                DeleteData(Area.dataId, con);
                //                InnitialAreas.Remove(Area);
                //                break;
                //            }
                //        }
                //    }

                //    foreach (int id in ChangedAreaList)
                //    {
                //        if (CreatedAreaList.Exists(i => i == id))
                //        {
                //            CreatedAreaList.Remove(id);
                //            foreach (AnnotationArea Area in AreaList)
                //            {
                //                if (Area.id == id)
                //                {
                //                    AddNewData(Area, con);
                //                    AreaList.Remove(Area);
                //                    break;
                //                }
                //            }
                //        }
                //        else
                //        {
                //            foreach (AnnotationArea Area in AreaList)
                //            {
                //                if (Area.id == id)
                //                {
                //                    UpdateData(Area, con);
                //                    AreaList.Remove(Area);
                //                    InnitialAreas.Remove(Area);
                //                    break;
                //                }
                //            }
                //        }
                //    }

                //    foreach (int id in CreatedAreaList)
                //    {
                //        foreach (AnnotationArea Area in AreaList)
                //        {
                //            if (Area.id == id)
                //            {
                //                AddNewData(Area, con);
                //                break;
                //            }
                //        }
                //    }
                    
                foreach(AnnotationArea Area in AreaList)
                {
                    AddNewData(Area, con);
                    continue;
                }
                AreaList.Clear();
                foreach(AnnotationArea Area in InnitialAreas)
                {
                    DeleteData(Area.dataId, con);
                }
                InnitialAreas.Clear();

                con.Close();
                NextImage_Click(sender, e); 
                Session["update"] = Server.UrlEncode(System.DateTime.Now.ToString());
            }
        }

        private void UpdateData(AnnotationArea Area, SqlConnection con)
        {
            int DataId = Area.dataId;
            string query = "UPDATE [dbo].[Coordinates] SET X = @X, Y = @Y, Height = @Height, Width = @Width, Label = @Label WHERE Id = @ID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.Add("@ID", SqlDbType.Int);
            cmd.Parameters.Add("@X", SqlDbType.Int);
            cmd.Parameters.Add("@Y", SqlDbType.Int);
            cmd.Parameters.Add("@Height", SqlDbType.Int);
            cmd.Parameters.Add("@Width", SqlDbType.Int);

            cmd.Parameters.AddWithValue("@Label", (Area.tag.Split(' ')[0]));

            cmd.Parameters["@ID"].Value = DataId;
            cmd.Parameters["@X"].Value = (int)(Area.x/ Double.Parse(RatioOfX.Value));
            cmd.Parameters["@Y"].Value = (int)(Area.y/ Double.Parse(RatioOfY.Value));
            cmd.Parameters["@Width"].Value = (int)(Area.width/ Double.Parse(RatioOfX.Value));
            cmd.Parameters["@Height"].Value = (int)(Area.height/ Double.Parse(RatioOfY.Value));

            cmd.ExecuteNonQuery();
        }

        private void AddNewData(AnnotationArea Area, SqlConnection con)
        {
            string query = "INSERT INTO [dbo].[Coordinates] VALUES (@ImageId, @AreaId, @X, @Y, @Height, @Width, @Label )";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.Add("@ImageId", SqlDbType.Int);
            cmd.Parameters.Add("@AreaId", SqlDbType.Int);
            cmd.Parameters.Add("@X", SqlDbType.Int);
            cmd.Parameters.Add("@y", SqlDbType.Int);
            cmd.Parameters.Add("@Height", SqlDbType.Int);
            cmd.Parameters.Add("@Width", SqlDbType.Int);

            cmd.Parameters["@ImageId"].Value = currentImageId;
            cmd.Parameters["@AreaId"].Value = Area.id;
            cmd.Parameters["@X"].Value = (int)(Area.x/ Double.Parse(RatioOfX.Value));
            cmd.Parameters["@Y"].Value = (int)(Area.y/ Double.Parse(RatioOfY.Value));
            cmd.Parameters["@Width"].Value = (int)(Area.width/ Double.Parse(RatioOfX.Value));
            cmd.Parameters["@Height"].Value = (int)(Area.height/ Double.Parse(RatioOfY.Value));
            cmd.Parameters.AddWithValue("@Label", (Area.tag.Split(' '))[0]);

            cmd.ExecuteNonQuery();
        }

        private void DeleteData(int DataId, SqlConnection con)
        {
            string query = "DELETE FROM [dbo].[coordinates] WHERE Id = @ID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.Add("@ID", SqlDbType.Int);
            cmd.Parameters["@ID"].Value = DataId;
            cmd.ExecuteNonQuery();
        }

    }
}