<!-- #include file="connect_1517264.asp" -->
<%  
    function Ceil(Number)
        Ceil = Int(Number)
        if Ceil<>Number then
            Ceil = Ceil + 1
        end if
    end function

    function checkPage(cond, ret)
        if cond = true then
            Response.write ret
        else
            Response.write ""
        end if
    end function

    page = Request.Item("page")
    limit = 2+5
    i=0

    if (trim(page) = "") or (isnull(page)) then
        page = 1
    end if

    offset = (Clng(page) * Clng(limit)) - Clng(limit)

    strSQL = "SELECT COUNT(id) AS count FROM posts"

    Set CountResult = connDB.execute(strSQL)

    totalRows = CLng(CountResult("count"))

    Set CountResult = Nothing

    pages = Ceil(totalRows/limit)
%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <link rel="icon" type="image/x-icon" href="favicon.ico" />
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <link href="../assets/dist/css/bootstrap.min.css" rel="stylesheet"  crossorigin="anonymous">
        <title>CRUD Example</title>
    </head>
    <body>
    <form action="index_1517264.asp" method="post">
        <!-- #include file="header_1517264.asp" -->

        <div class="container">
            <div class="d-flex bd-highlight mb-3">
                <div class="me-auto p-2 bd-highlight"><h2>Danh sách bài viết</h2></div>
                <div class="p-2 bd-highlight" >
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Tìm kiếm theo tiêu đề" name="title" >
                        <input type="submit" class="btn btn-primary" value="Tìm kiếm" name="search">
                    </div>
                <%= checkPage(Session("role") = 2, "<a href='/addedit_1517264.asp' class='btn btn-primary'>Create</a>") %>
                <%
                Dim title 
                title = Request.Form("title")
               %>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table " id="myTable">
                    <thead>
                        <tr>
                            <th scope="col" onclick="sortTable(0)">Số thứ tự</th>
                            <th scope="col" onclick="sortTable(1)">Tiêu đề</th>
                            <th scope="col" onclick="sortTable(2)">Mô tả</th>
                            <th scope="col">Chủ sở hữu</th>
                            <th scope="col">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Set cmdPrep = Server.CreateObject("ADODB.Command")
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            cmdPrep.CommandText = "SELECT posts.id as id,title,description,users.name as username FROM posts INNER JOIN users ON posts.user_id= users.id where title like '%"+title+"%' ORDER BY id OFFSET ?  ROWS FETCH NEXT ? ROWS ONLY"
                            cmdPrep.parameters.Append cmdPrep.createParameter("offset", 3, 1, , offset)
                            cmdPrep.parameters.Append cmdPrep.createParameter("limit", 3, 1, , limit)
            
                            Set Result = cmdPrep.execute
                            do while not Result.EOF
                        %>
                                <tr>
                                    <td ><%= i+1 %></td>
                                    <td><%=Result("title")%></td>
                                    <td><%=Result("description")%></td>
                                    <td><%=Result("username")%></td>
                                    <td>
                                        <%= checkPage(Session("role") = 2, "<a href='/addedit_1517264.asp?id=" & Result("id") & "' class='btn btn-primary'>Edit</a>") %>
                                        <a href="/view_1517264.asp?id=<%=Result("id")%>" class="btn btn-success">View</a>
                                        <%= checkPage(Session("role") = 2, "<a data-href='delete_1517264.asp?id=" & Result("id") & "' class='btn btn-danger' data-bs-toggle='modal' data-bs-target='#confirm-delete' alt='Delete' title='Delete'>Delete</a>") %>
                                    </td>
                                </tr>
                        <%
                                Result.MoveNext
                                i=i+1
                            loop
                        %>
                    </tbody>
                </table>
            </div>
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center fixed-bottom">
                    <% if (pages > 1) then %>
                        <% for i = 1 to pages %>
                            <li class="page-item <%=checkPage(Clng(i)=Clng(page),"active")%>"><a class="page-link" href="index_1517264.asp?page=<%=i%>"><%=i%></a></li>
                        <% next %>
                    <% end if %>
                </ul>
            </nav>
            <div class="modal" tabindex="-1" id="confirm-delete">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Delete Confirmation</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure?</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <a class="btn btn-danger btn-delete">Delete</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="../assets/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        
        <script>
            var count = 0;
            $(function()
            {
                $('#confirm-delete').on('show.bs.modal', function(e){
                    $(this).find('.btn-delete').attr('href', $(e.relatedTarget).data('href'));
                });
            });
            function sortTable(n) {
                var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                table = document.getElementById("myTable");
                switching = true;
                dir = "asc";
                while (switching) {
                    switching = false;
                    rows = table.rows;
                    for (i = 1; i < (rows.length - 1); i++) {
                    shouldSwitch = false;
                    x = rows[i].getElementsByTagName("TD")[n];
                    y = rows[i + 1].getElementsByTagName("TD")[n];
                    if (dir == "asc") {
                        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                        shouldSwitch = true;
                        break;
                        }
                    } else if (dir == "desc") {
                        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                        shouldSwitch = true;
                        break;
                        }
                    }
                    }
                    if (shouldSwitch) {
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                    switchcount ++;
                    } else {
                    if (switchcount == 0 && dir == "asc") {
                        dir = "desc";
                        switching = true;
                    }
                    }
                }
                }
  
        </script>
    </form>
    </body>
</html>
<%
    connDB.close()
    set connDB = Nothing
%>