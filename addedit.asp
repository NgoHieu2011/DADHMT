<!-- #include file="connect.asp" -->
<%
    If (isnull(Session("email"))) OR (Trim(Session("email"))="") Then
        If (isnull(Request.ServerVariables("Query_String"))) OR (Trim(Request.ServerVariables("Query_String"))="") Then
            Session("CurrentPage")=Request.ServerVariables("URL")
        Else
            Session("CurrentPage")=Request.ServerVariables("URL") & "?" & Request.ServerVariables("Query_String")
        End If
        Response.redirect("/login.asp")
    End If
    If (Request.ServerVariables("Request_Method") = "GET") Then
        id = Request.QueryString("id")

        If (trim(id) = "") or (isnull(id)) then id = 0 end if
        If (cint(id) <> 0) Then

            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SELECT * FROM NHANVIEN WHERE MANV=?"
            cmdPrep.parameters.Append cmdPrep.createParameter("id", 3, 1, , cint(id))
            
            Set Result = cmdPrep.execute

            if not Result.EOF then
                name = Result("HoTenNV")
                hometown = Result("QueQuan")
            End If

            Set Result = Nothing
        End If
    Else
        id = Request.form("id")
        name = Request.form("name")
        hometown = Request.form("hometown")

        If (trim(id) = "") or (isnull(id)) then id = 0 end if

        if cint(id) = 0 then

            If (NOT isnull(name) and (name<>"")) and (NOT isnull(hometown) and (hometown<>"")) Then
                'strSQL="INSERT INTO NHANVIEN(HoTenNV,QueQuan) values ('" & name & "','" & hometown & "')"
                'connDB.execute(strSQL)

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "INSERT INTO NHANVIEN(HoTenNV,QueQuan) values (?,?)"
                cmdPrep.parameters.Append cmdPrep.createParameter("name", 202, 1, 50, name)
                cmdPrep.parameters.Append cmdPrep.createParameter("hometown", 202, 1, 200, hometown)
            
                cmdPrep.execute

                Session("Success")="Add a new employee successfully"
                Response.redirect("/")
            Else
                Session("Error")="You have to input info"
            End if
        Else
            If (NOT isnull(name) and (name<>"")) and (NOT isnull(hometown) and (hometown<>"")) Then
                'strSQL="UPDATE NHANVIEN Set HoTenNV='" & name &"',QueQuan='" & hometown & "' WHERE MaNV=" & id
                'connDB.execute(strSQL)

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE NHANVIEN Set HoTenNV=?,QueQuan=? WHERE MaNV=?"
                cmdPrep.parameters.Append cmdPrep.createParameter("name", 202, 1, 50, name)
                cmdPrep.parameters.Append cmdPrep.createParameter("hometown", 202, 1, 200, hometown)
                cmdPrep.parameters.Append cmdPrep.createParameter("id", 3, 1, , cint(id))
            
                cmdPrep.execute

                Session("Success")="Edit  successfully"
                Response.redirect("/")
            Else
                Session("Error")="You have to input info"
            End if            
        End if
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
        <!-- #include file="header.asp" -->

        <div class="container">
            <form method="post" action="addedit.asp">
                <div class="mb-3">
                    <label for="name" class="form-label">Ho va ten</label>
                    <input type="text" class="form-control" id="name" name="name" value="<%=name%>">
                </div>
                <div class="mb-3">
                    <label for="hometown" class="form-label">Que Quan</label>
                    <input type="text" class="form-control" id="hometown" name="hometown" value="<%=hometown%>">
                </div>
                <div class="row">
                    <div class="form-group">
                        <input type="hidden" name="id" id="id" value="<%=id%>">
                        <button type="submit" class="btn btn-primary">
                            <%
                                if (id=0) then
                                    Response.write("Create")
                                else
                                    Response.write("Edit")
                                end if
                            %>
                        </button>
                        <a href="index.asp" class="btn btn-info">Cancel</a>
                    </div>
                </div>
            </form>
        </div>

        <script src="../assets/dist/js/bootstrap.bundle.min.js"  crossorigin="anonymous"></script>
    </body>
</html>