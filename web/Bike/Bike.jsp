<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="Kernel.jsp" %>
<!doctype html>
<html lang="zh-TW">
    <head>
        <!-- Document metadata goes here -->
    </head>
    <frameset cols="200,*">
        <!-- frameset 用來左右分割畫面，左邊200px，剩下的全部空間(*) -->

        <frame src="Bike_Menu.jsp" name="BikeMenu"/>
        <!-- frame 左側畫面載入Menu.jsp -->

        <frame src="Bike_List.jsp" name="BikeBody"/>


    </frameset>
</html>
