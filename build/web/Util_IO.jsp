<%@page pageEncoding="UTF-8"%>
<%!
    public String isChecked(String str1, String str2) throws Exception {
        if (str1 == null || str2 == null) {
            return "";
        }
        if (str1.equals(str2)) {
            return "checked";
        } else if (str1.indexOf(str2) > -1) {
            return "checked";
        } else {
            return "";
        }
    }

    public String isCheckedforcheckBox(String source, String target) {

        if (source == null) {
            return "";
        }

        if (source.indexOf(target) != -1) {
            return "checked";
        }
        return "";
    }

    public String isSelected(String str1, String str2) throws Exception {
        if (str1.equals(str2)) {
            return "selected";
        } else {
            return "";
        }
    }

    String req(String Name, HttpServletRequest requ) throws Exception {
        String Value = requ.getParameter(Name);
        if (Value == null) {
            Value = "";
        }

        return Value;
    }

    String reqValues(String Name, HttpServletRequest request) throws Exception {
        String hoobbystr = "";
        String hobby[] = request.getParameterValues(Name);
        if (hobby != null) {
            for (int i = 0; i < hobby.length; i++) {

                hoobbystr += hobby[i] + ",";

            }

        }
        return hoobbystr = "," + hoobbystr;
    }

    boolean isPost(javax.servlet.http.HttpServletRequest requ) {
        if (requ.getMethod().toString().equals("GET")) {
            return false;
        } else {
            return true;
        }
    }

    public String toStr(String value) {
        return "'" + value.replaceAll("'", "''") + "'";
    }

    public void setSession(String Name, String Value, javax.servlet.http.HttpSession Session) {
        Session.setAttribute(Name, Value);
    }

    public String getSession(String Name, javax.servlet.http.HttpSession Session) {
        if (Session == null) {
            return "";
        }
        String value = (String) Session.getAttribute(Name);
        if (value != null) {
            return value;
        }
        return "";
    }

%>
