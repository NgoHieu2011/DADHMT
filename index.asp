<!-- #include file="connect.asp" -->
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
    limit = 6
    i=0

    if (trim(page) = "") or (isnull(page)) then
        page = 1
    end if

    offset = (Clng(page) * Clng(limit)) - Clng(limit)

    strSQL = "SELECT COUNT(MANV) AS count FROM NHANVIEN"

    Set CountResult = connDB.execute(strSQL)

    totalRows = CLng(CountResult("count"))

    Set CountResult = Nothing

    pages = Ceil(totalRows/limit)
%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <link href="../assets/dist/css/bootstrap.min.css" rel="stylesheet"  crossorigin="anonymous">
        <title>CRUD Example</title>
    </head>
    <body>
        <!-- #include file="header.asp" -->

        <div class="container">
            <div class="d-flex bd-highlight mb-3">
                <div class="me-auto p-2 bd-highlight"><h2>Danh sách nhân viên</h2></div>
                <div class="p-2 bd-highlight">
                    <a href="/addedit.asp" class="btn btn-primary">Create</a>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Số thứ tự</th>
                            <th scope="col">Mã Nhân Viên</th>
                            <th scope="col">Họ Tên Nhân Viên</th>
                            <th scope="col">Quê Quán</th>
                            <th scope="col">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Set cmdPrep = Server.CreateObject("ADODB.Command")
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            cmdPrep.CommandText = "SELECT * FROM NHANVIEN ORDER BY MANV OFFSET ?  ROWS FETCH NEXT ? ROWS ONLY"
                            cmdPrep.parameters.Append cmdPrep.createParameter("offset", 3, 1, , offset)
                            cmdPrep.parameters.Append cmdPrep.createParameter("limit", 3, 1, , limit)
            
                            Set Result = cmdPrep.execute
                            do while not Result.EOF
                        %>
                                <tr>
                                    <td ><%= i+1 %></td>
                                    <td><%=Result("MaNV")%></td>
                                    <td><%=Result("HoTenNV")%></td>
                                    <td><%=Result("QueQuan")%></td>
                                    <td>
                                        <a href="addedit.asp?id=<%=Result("MaNV")%>" class="btn btn-secondary">Edit</a>
                                        <a data-href="delete.asp?id=<%=Result("MaNV")%>" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#confirm-delete" alt="Delete" title="Delete">Delete</a>
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
                            <li class="page-item <%=checkPage(Clng(i)=Clng(page),"active")%>"><a class="page-link" href="index.asp?page=<%=i%>"><%=i%></a></li>
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
            $(function()
            {
                $('#confirm-delete').on('show.bs.modal', function(e){
                    $(this).find('.btn-delete').attr('href', $(e.relatedTarget).data('href'));
                });
            });
        </script>
    </body>
</html>
<%
    connDB.close()
    set connDB = Nothing
%>