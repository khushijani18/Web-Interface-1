<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="WebForm2.aspx.cs" Inherits="WebInterfaceDsign.WebForm2" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Annotate Images Here</title>

    

   
    <style>

        body {
  
}

@media only screen and (max-width: 600px) {
  body {
    background-color: lightblue;
  }
}
        .img {
            float: left;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-top: 20px;
            margin-left: 20px;
            padding: 5px;
        }



        .ImageProcess {
            max-width: 100%;
            max-height: 80vh;
        }
        
        .next {
            color: black;
            font-size: 20px;
            padding: 10px 20px;
            border-radius: 10px 10px 10px;
            background-color: lightgreen;
        }

        .pre {
            color: black;
            font-size: 20px;
            padding: 10px 20px;
            
            background-color: lightgreen;
            border-radius: 10px 10px 10px;
        }

        .set {
            color: white;
            font-size: 20px;
            padding: 10px 20px;
            background-color: hotpink;
            border-radius: 10px 10px 10px;
        }

        .val {
            color: brown;
            font-size: 16px;
            padding: 10px 20px;
            background-color: lightblue;
            border-radius: 10px 10px 10px;
        }

        .autocomplete {
            position: relative;
            display: inline-block;
        }

        input {
            border: 1px solid transparent;
            background-color: #f1f1f1;
            padding: 10px;
            font-size: 16px;
        }

            input[type=text] {
                background-color: #f1f1f1;
                width: 100%;
            }



        .autocomplete-items {
            position: absolute;
            border: 1px solid #d4d4d4;
            border-bottom: none;
            border-top: none;
            z-index: 99;
            /*/position the autocomplete items to be the same width as the container:/ top: 100%;*/
            left: 0;
            right: 0;
        }

            .autocomplete-items div {
                padding: 10px;
                cursor: pointer;
                background-color: #fff;
                border-bottom: 1px solid #d4d4d4;
            }

       
        .autocomplete-items div:hover {
            background-color: #e9e9e9;
        }

        /*/when navigating through the items using the arrow keys:/*/
        .autocomplete-active {
            background-color: DodgerBlue !important;
            color: #ffffff;
        }

        .img {
            max-width: 100%;
        }
    </style>

    <script type="text/javascript">

        console.log("In Script");

        var imgNaturalHeight = 0;
        var imgNaturalWidth = 0;
        var resizedHeight = 0;
        var resizedWidth = 0;
        var currentAreaId = -1;
        var currentArea = null;
        var areaChanged = "false";
        var deletedAreas = [];
        var changedAreas = [];
        var createdAreas = [];
        var innitialAreas = [];
        var isAreaChanged = false;
        var currentArea;
        var tag;
        var ratio_of_x = 0.0;
        var ratio_of_y = 0.0;

        
        function StringifyArrays() {
            console.log("In stringifyareas");
            $('#<%=DeletedAreas.ClientID%>').val(JSON.stringify(deletedAreas));
            $('#<%=ChangedAreas.ClientID%>').val(JSON.stringify(changedAreas));
            $('#<%=CreatedAreas.ClientID%>').val(JSON.stringify(createdAreas));
            return true;
        }

        $(document).ready(function () {

            console.log("Document is ready");

            //Fired when the image is loaded for the first time
            <%--$("#<%=ImageToProcess.ClientID%>").on('load', function () { --%>
            
            
            imgNaturalHeight = $('#<%=ImageToProcess.ClientID%>').get(0).naturalHeight;
            imgNaturalWidth = $('#<%=ImageToProcess.ClientID%>').get(0).naturalWidth;
            resizedHeight = $('#<%=ImageToProcess.ClientID%>').get(0).height;
            resizedWidth = $('#<%=ImageToProcess.ClientID%>').get(0).width;

            ratio_of_x = resizedWidth / imgNaturalWidth;
            ratio_of_y = resizedHeight / imgNaturalHeight;

            $('#<%=RatioOfX.ClientID%>').val(ratio_of_x);
            $('#<%=RatioOfY.ClientID%>').val(ratio_of_y);

                var array = new Array(($('#<%=ImageAreas.ClientID%>').val()).split("~"));
            console.log(array);

            <%--$('#<%=ImageToProcess.ClientID%>').on('load', function () {
                console.log("Image Loaded");      --%>
                //To make image rectangle selectable
                $("#<%=ImageToProcess.ClientID%>").selectAreas({
                    allowEdit : true,
                    allowMove : true,
                    allowSelect:true,
                    allowNudge: false,
                    aspectRatio: 0,
                    outlineOpacity : 1,
                    overlayOpacity : 0.6,
                    minSize : [15,15],
                });

                console.log("Image is area selectable");

                //To Add Initial Selected Areas retrived from database
                for (var i = 0; i < array[0].length; i++)
                {
                    
                    console.log("Array :- " + array[0][i]);
                    var coordinates = new Array((String(array[0][i])).split(","));
                    console.log("Coordinates :- " + coordinates);
                    innitialAreas.push(parseInt(coordinates[0][0]));
                    if (coordinates != "") 
                    {
                        var option = {
                            id: parseInt(coordinates[0][0]),
                            x: (parseInt(coordinates[0][1]) * ratio_of_x),
                            y: (parseInt(coordinates[0][2]) * ratio_of_y),
                            width: (parseInt(coordinates[0][3]) * ratio_of_x),
                            height: (parseInt(coordinates[0][4]) * ratio_of_y),
                            tag: coordinates[0][5],
                        };
                        $("#<%=ImageToProcess.ClientID%>").selectAreas('add', option);
                    }
                }
            //});
                
            
            
            $('#<%=UploadData.ClientID%>').click(function () {
                console.log("Uploading Data");
                var data = JSON.stringify($('#<%=ImageToProcess.ClientID%>').selectAreas('areas'));
                console.log(data);
                $('#<%=ImageJsonData.ClientID%>').val(data);

                $('#<%=DeletedAreas.ClientID%>').val(JSON.stringify(deletedAreas));
                console.log(deletedAreas);
                $('#<%=ChangedAreas.ClientID%>').val(JSON.stringify(changedAreas));
                console.log(changedAreas);
                $('#<%=CreatedAreas.ClientID%>').val(JSON.stringify(createdAreas));
                console.log(createdAreas);
            });

            //FIred When New selection is Done or previous selection is selected
            $('#<%=ImageToProcess.ClientID%>').on("changed", function (event, id, areas) {
                console.log("In Changed event");
                if (isAreaChanged) {
                    isAreaChanged = false;
                }

                document.getElementById("myInput").focus();
                for (var i = 0; i < areas.length; i++) {
                    if (areas[i].id == id) {
                        currentArea = areas[i];
                    }
                }

                if (currentArea.tag == null) {
                    document.getElementById("myInput").value = "";
                }
                else {
                    document.getElementById("myInput").value = (currentArea.tag.split(" "))[0];
                }
                
            });

            $('#tag-input').click(function () {
                var newTag = document.getElementById("myInput").value;
                newTag += " " + "[ (" + parseInt((currentArea.x) / ratio_of_x) + "," + parseInt((currentArea.y) / ratio_of_y) + "),";
                newTag += " (" + parseInt((currentArea.width) / ratio_of_x) + "," + parseInt((currentArea.height) / ratio_of_y) + ") ]";
                $('#<%=ImageToProcess.ClientID%>').selectAreas('setTag', currentArea.id, newTag);

            });

            //Fired When Selecting The area
            $('#<%=ImageToProcess.ClientID%>').on('changing', function (event, id, areas) {
                if (!isAreaChanged) {
                    isAreaChanged = true;
                    for (var i = 0; i < areas.length; i++) {
                        if (areas[i].id == id) {
                            currentArea = areas[i];
                            tag = currentArea.tag;
                            tag = (tag.split(" "))[0];
                        }
                    }
                }
                console.log("In Changing Event");
                console.log(areas);
                var newTag = tag + " " + "[ (" + parseInt((currentArea.x) / ratio_of_x) + "," + parseInt((currentArea.y) / ratio_of_y) + "),";
                newTag += " (" + parseInt((currentArea.width) / ratio_of_x) + "," + parseInt((currentArea.height) / ratio_of_y) + ") ]";
            
                $('#<%=ImageToProcess.ClientID%>').selectAreas('setTag', currentArea.id, newTag);
            });


            //Fired when area is deleted
            $('#<%=ImageToProcess.ClientID%>').on('deleted', function (event, id, areas) {
                console.log(id + "id deleted");
                //Set when all area are deleted
                if (areas.length == 0) {
                    $('#<%=AllDeleted.ClientID%>').val("ture");
                }

                //for (var i = 0; i < createdAreas.length; i++)
                //{
                //    if (createdAreas[i] == id) {
                //        createdAreas.splice(i, 1);
                //        break;
                //    }
                //}
                //changedAreas.filter(function (areaId) {
                //    return areaId != id;
                //});
                deletedAreas.push(id);
            });
            
            function StringifyAreas() {
                var data = JSON.stringify($('#<%=ImageToProcess.ClientID%>').selectAreas('areas'));
                $('#<%=ImageJsonData.ClientID%>').val(data);
            }
            
            function OnAreaChanged(event, id, areas) {
                console.log(id + "Area Is changed...");
                console.log(areas);
            }

            function OnAreaDeleted(event, id, areas) {
                console.log(id + "Area is deleted");
                console.log(areas);
            }

            function OnAreaChanging(event, id, areas) {
                console.log(areas);
            }

        });
    </script>

</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="BodyContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12 col-md-9">
                <div class="img" >
                    <asp:Image ID="ImageToProcess" CssClass="ImageProcess" runat="server" ImageUrl="~/Resources/Images/download2.jpg"  />
                </div>
            </div>
           <div class="column">
        <div class="col-xs-5 col-sm-2">
                        <asp:Button ID="PreviousImage" runat="server" Text="Previous" CssClass="pre" OnClick="PreviousImage_Click"/> 
                    </div>
                    <div class="col-xs-8 col-sm-1">
                        <asp:Button ID="NextImage" runat="server" Text="Next" CssClass="next" OnClick="NextImage_Click" />
                    </div>
                  <br /><br /><br /><br /><br />
                    
                    
                </div>
                <div class="autocomplete" style="width:300px;">
                <input id="myInput" type="text" name="myCountry">

            </div>


            <script>
                function autocomplete(inp, arr) {
                    /*the autocomplete function takes two arguments,
                    the text field element and an array of possible autocompleted values:*/
                    var currentFocus;
                    /execute a function when someone writes in the text field:/
                    inp.addEventListener("input", function (e) {
                        var a, b, i, val = this.value;
                        /close any already open lists of autocompleted values/
                        closeAllLists();
                        if (!val) { return false; }
                        currentFocus = -1;
                        /create a DIV element that will contain the items (values):/
                        a = document.createElement("DIV");
                        a.setAttribute("id", this.id + "autocomplete-list");
                        a.setAttribute("class", "autocomplete-items");
                        /append the DIV element as a child of the autocomplete container:/
                        this.parentNode.appendChild(a);
                        /for each item in the array.../
                        for (i = 0; i < arr.length; i++) {
                            /check if the item starts with the same letters as the text field value:/
                            if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
                                /create a DIV element for each matching element:/
                                b = document.createElement("DIV");
                                /make the matching letters bold:/
                                b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
                                b.innerHTML += arr[i].substr(val.length);
                                /insert a input field that will hold the current array item's value:/
                                b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
                                /execute a function when someone clicks on the item value (DIV element):/
                                b.addEventListener("click", function (e) {
                                    /insert the value for the autocomplete text field:/
                                    inp.value = this.getElementsByTagName("input")[0].value;
                                    /*close the list of autocompleted values,
                                    (or any other open lists of autocompleted values:*/
                                    closeAllLists();
                                });
                                a.appendChild(b);
                            }
                        }
                    });
                    /execute a function presses a key on the keyboard:/
                    inp.addEventListener("keydown", function (e) {
                        var x = document.getElementById(this.id + "autocomplete-list");
                        if (x) x = x.getElementsByTagName("div");
                        if (e.keyCode == 40) {
                            /*If the arrow DOWN key is pressed,
                            increase the currentFocus variable:*/
                            currentFocus++;
                            /and and make the current item more visible:/
                            addActive(x);
                        } else if (e.keyCode == 38) { //up
                            /*If the arrow UP key is pressed,
                            decrease the currentFocus variable:*/
                            currentFocus--;
                            /and and make the current item more visible:/
                            addActive(x);
                        } else if (e.keyCode == 13) {
                            /If the ENTER key is pressed, prevent the form from being submitted,/
                            e.preventDefault();
                            if (currentFocus > -1) {
                                /and simulate a click on the "active" item:/
                                if (x) x[currentFocus].click();
                            }
                        }
                    });
                    function addActive(x) {
                        /a function to classify an item as "active":/
                        if (!x) return false;
                        /start by removing the "active" class on all items:/
                        removeActive(x);
                        if (currentFocus >= x.length) currentFocus = 0;
                        if (currentFocus < 0) currentFocus = (x.length - 1);
                        /add class "autocomplete-active":/
                        x[currentFocus].classList.add("autocomplete-active");
                    }
                    function removeActive(x) {
                        /a function to remove the "active" class from all autocomplete items:/
                        for (var i = 0; i < x.length; i++) {
                            x[i].classList.remove("autocomplete-active");
                        }
                    }
                    function closeAllLists(elmnt) {
                        /*close all autocomplete lists in the document,
                        except the one passed as an argument:*/
                        var x = document.getElementsByClassName("autocomplete-items");
                        for (var i = 0; i < x.length; i++) {
                            if (elmnt != x[i] && elmnt != inp) {
                                x[i].parentNode.removeChild(x[i]);
                            }
                        }
                    }
                    /execute a function when someone clicks in the document:/
                    document.addEventListener("click", function (e) {
                        closeAllLists(e.target);
                    });
                }
                var tags = ["dog", "cat", "mouse","car","Table" ,"Chair","Bottle" , "Box" ,"Pen","Pencil" ,"Laptop","Butterfly"];
                autocomplete(document.getElementById("myInput"), tags);
            </script>
       
         
            <br /><br />
  <br /><br /><br /><br /><br />

            
  
               
           
                <div class="col-xs-6 col-sm-2">
                    <input type="button" id="tag-input" class="set" value="Set Tag" />
                </div>
                 <br /><br /><br /><br /><br />
 
                     <div class="col-xs-7 col-md-3">
                    <asp:Button ID="UploadData" runat="server" Text="Validate and go to next image" CssClass="val" OnClientClick="return StringifyArrays()" OnClick="UploadData_Click"  />
                </div>
                <%--<asp:Button runat="server" Text="Set Tag" CssClass="btn2"></asp:Button>--%>
  
        </div></div>
    <asp:HiddenField ID="ImageAreas" runat="server" />
    <asp:HiddenField ID="AnyAreaChanged" runat="server" Value="false" />
    <asp:HiddenField ID="ImageJsonData" runat="server" />
    <asp:HiddenField ID="DeletedAreas" runat="server" />
    <asp:HiddenField ID="ChangedAreas" runat="server" />
    <asp:HiddenField ID="CreatedAreas" runat="server" />
    <asp:HiddenField ID="AllDeleted" runat="server" Value="false" />
    <asp:HiddenField ID="RatioOfX" runat="server" />
    <asp:HiddenField ID="RatioOfY" runat="server" />
</asp:Content>
