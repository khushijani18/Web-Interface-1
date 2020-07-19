<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="IMageUpload.aspx.cs" Inherits="WebInterfaceDsign.IMageUpload" %>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    
    <title>Upload Your Images Here</title>
  
</head>
<body>
    <form id="form1">
        <div id="label_box" runat="server">
            <asp:Label runat="server" Text="" ID="Upload_Status" Font-Size="Large" ></asp:Label>
            <br />
            <br />
        </div>
        <div>

            <asp:FileUpload ID="FileUpload1" runat="server" AllowMultiple="True" />

        </div>
         <br />
            <br />
         <br />
           
        <p>
            <asp:Button ID="btn_save" runat="server" OnClick="btn_save_Click" Text="Upload Images" Width="120px" />
        </p>
        <br />
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <img src= 'Resources/Images/<%#Eval("name") %>' alt="" height="150" />
            </ItemTemplate>
          
        </asp:Repeater>
        <br />
       
          <asp:GridView runat="server" ID="GridView1" AutoGenerateColumns="true">
           

          </asp:GridView>
        

    </form>
</body>
</html>

</asp:Content>
