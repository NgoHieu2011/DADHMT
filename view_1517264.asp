<!-- #include file="connect_1517264.asp" -->
<%  
    If (isnull(Session("email"))) OR (Trim(Session("email"))="") Then
        If (isnull(Request.ServerVariables("Query_String"))) OR (Trim(Request.ServerVariables("Query_String"))="") Then
            Session("CurrentPage")=Request.ServerVariables("URL")
        Else
            Session("CurrentPage")=Request.ServerVariables("URL") & "?" & Request.ServerVariables("Query_String")
        End If
        Response.redirect("/login_1517264.asp")
    End If
    If (Request.ServerVariables("Request_Method") = "GET") Then
        id = Request.QueryString("id")

        If (trim(id) = "") or (isnull(id)) then id = 0 end if
        If (cint(id) <> 0) Then

            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SELECT posts.id as id,title,description,content,user_id,create_date,update_date FROM posts WHERE id=?"
            cmdPrep.parameters.Append cmdPrep.createParameter("id", 3, 1, , cint(id))
            
            Set Result = cmdPrep.execute

            if not Result.EOF then
                title = Result("title")
                description = Result("description")
                content = Result("content")
                user_id = Result("user_id")
                create_date = Result("create_date")
                update_date = Result("update_date")
            End If

            Set Result = Nothing
        End If
    End if
%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <link href="../assets/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <title>CRUD Example</title>
    </head>
    <body>
        <!-- #include file="header_1517264.asp" -->

        <div class="container">
            <form method="post" action="view_1517264.asp">
                <div class="mb-3">
                    <label for="title" class="form-label">Tiêu đề : <%=title%></label>
                </div>
                <div class="mb-3">
                    <label for="description" class="form-label">Mô tả: <%=description%></label>
                </div>
                <div class="mb-3">
                    <label for="content" class="form-label">Nội dung : <%=content%></label>
                </div>
                <div class="row">
                    <div class="form-group ">
                        <a href="index_1517264.asp" class="btn btn-info">Close</a>
                    </div>
                </div>
            </form>
        </div>

        <script src="../assets/dist/js/bootstrap.bundle.min.js"  crossorigin="anonymous"></script>
    </body>
</html>