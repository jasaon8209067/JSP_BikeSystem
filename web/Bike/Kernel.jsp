<%@page pageEncoding="UTF-8"%>
<%--<%@ include file="/Util_IO.jsp" %>--%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

//    String J_OrgId = getSession("J_OrgId", session);
//    String J_OrgName = getSession("J_OrgName", session);
    String J_OrgId = (String) session.getAttribute("J_OrgId");
    String J_OrgName = (String) session.getAttribute("J_OrgName");

    if (J_OrgId == null || J_OrgId.equals("")) {
        response.sendRedirect("/Login.jsp");
        return;
    }
%>