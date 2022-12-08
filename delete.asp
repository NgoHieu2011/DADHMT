<!-- #include file="connect.asp" -->
<%
'Sinh vien xu ly delete chi trong truong hop dang nhap + chuyen sang ADODB.Command
    id = Request.QueryString("id")

    if trim(id) = "" or isnull(id) then
        Response.Write("<script>alert('Cannot delete');document.location='index.asp';</script>")
        Response.End
    end if

    strSQL = "DELETE FROM NHANVIEN WHERE MANV=" & id

    connDB.execute(strSQL)

    Response.Redirect("index.asp")
    Response.End

%>
