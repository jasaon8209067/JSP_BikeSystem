<%@page import="java.lang.annotation.Target"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="Kernel.jsp" %>
<%@ include file="/Util_IO.jsp" %>
<%
    //清空Session
    setSession("J_OrgId", "", session);//等於session.setAttribute("J_OrgId", "");也可以寫成session.invalidate();
    setSession("J_OrgName", "", session);
    
    out.print("<script>top.location.href='/Login.jsp';</script>");

%>
