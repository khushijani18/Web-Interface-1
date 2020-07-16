<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebInterfaceDsign.WebForm1" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Upload Images Here</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial;
        }

        .row {
            display: -ms-flexbox; /* IE10 */
            display: flex;
            -ms-flex-wrap: wrap; /* IE10 */
            flex-wrap: wrap;
            padding: 0 4px;
            border-left:solid 2px ;
            border-top-left-radius:2%;
        }

        /* Create four equal columns that sits next to each other */
        .column {
            -ms-flex: 21%; /* IE10 */
            flex: 21%;
            max-width: 21%;
            padding: 0 4px;
        
        }
        .column1 {
            -ms-flex: 25%; /* IE10 */
            flex: 25%;
            max-width: 25%;
            padding: 0 4px;
        }

        .column img {
            margin-top: 8px;
            vertical-align: middle;
        }

        .column1 img {
            margin-top: 8px;
            vertical-align: middle;
        }

        div.desc {
            padding: 15px;
            text-align: center;
        }


/* Responsive layout - makes a two column-layout instead of four columns */
        @media screen and (max-width: 800px) {
            .column {
                -ms-flex: 50%;
                flex: 50%;
            }

            .column1 {
                -ms-flex: 50%;
                flex: 50%;
            }
        }

/* Responsive layout - makes the two columns stack on top of each other instead of next to each other */
        @media screen and (max-width: 600px) {
            .column {
                -ms-flex: 100%;
                flex: 100%;
            }
             .column1 {
                -ms-flex: 100%;
                flex: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="BodyContent" runat="server">
    <div class ="bod">
        <div class="row"> 
            <div class="column">
                <img src="download4.jpg"> 
                <img src="download2.jpg"> 
            </div>
      
            <div class="column1">
                <img src="download3.jpg"> 
                <img src="download5.jpg"> 
            </div>
            <div class="desc">Add a description of the image here</div>
 
        </div>
    </div>
</asp:Content>
