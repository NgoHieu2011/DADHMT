<%
    Set connDB = Server.CreateObject("ADODB.Connection")
    strConnection = "Provider=SQLOLEDB; Data Source=localhost; Initial Catalog=QLNV;User id=sa; Password=123456"
    connDB.ConnectionString = strConnection
    connDB.Open
%>