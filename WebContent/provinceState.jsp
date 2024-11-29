<%@ page import="java.sql.*" %> <%
String country = request.getParameter("country");
if (country == null)
    out.println("INVALID");
else
{
    try 
    ( Connection con = DriverManager.getConnection(url,uid,pw); )
    {   String sql = "SELECT stateCode FROM states where countrycode=?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, country);
        ResultSet rst = pstmt.executeQuery();
        StringBuffer buf = new StringBuffer();
        while (rst.next()) {  
            buf.append(rst.getString(1));     
            buf.append(',');
        }
    if (buf.length() > 0)
        buf.setLength(buf.length()-1); 
    out.println(buf.toString());
%>