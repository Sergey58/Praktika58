<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>Mail sender</title>

  <script src="https://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script>
  <script src="https://code.jquery.com/jquery-3.1.1.js"
          integrity="sha256-16cdPddA6VdVInumRGo6IbivbERE8p7CQR3HzTBuELA="
          crossorigin="anonymous"></script>
  <link href="css/bootstrap.min.css"  rel="stylesheet">

  <script type="text/javascript">

  </script>

</head>

<body>

<script>
  function send_Message() {
      var email_adress = document.getElementById("email_adress").value;
      $.ajax ({
          url: "MyServlet",
          type: "GET",
          dataType: "text",
          data: ("email_adress=" + email_adress),
          success: function (data) {
              alert(data);
          },
          error: function (e) {
              alert("Query is not sended");
          }
      })
  }
</script>

<div class="form-group" style="margin: 40px">
  <label class="col-offset-4 col-4 control-label">Email</label>
  <div class="col-offset-4 col-4" style="width: 30%" align="center">
    <input type="text" class="form-control" placeholder="Введите адрес получателя" id="email_adress">
  </div>
</div>
<div class="form-group">
  <div class="col-offset-4 col-4" align="left" style="margin-left: 40px">
    <button type="button" class="btn btn-default" onclick="send_Message();">Отправить</button>
  </div>
</div>

<hr>

<script>
    function check(){
        var pass = "qwerty";
        var mpass = document.getElementById('password').value;
        var log = "user";
        var mlog = document.getElementById('login').value;


        if((mpass==pass)&&(mlog==log))
        {
            location.href="index2.jsp";
        }
        else
        {alert("Неправильные данные для входа")}
    }
</script>

<div class="form-group" style="margin: 40px">
  <label class="col-offset-4 col-4 control-label">Login</label>
  <div class="col-offset-4 col-4" style="width: 30%" align="center">
    <input type="text" class="form-control" placeholder="Введите имя пользователя" id="login">
  </div>

</div><div class="form-group" style="margin: 40px">
  <label class="col-offset-4 col-4 control-label">Password</label>
  <div class="col-offset-4 col-4" style="width: 30%" align="center">
    <input type="password" class="form-control" placeholder="Введите пароль" id="password">
  </div>
</div>

<div class="form-group">
  <div class="col-offset-4 col-4" align="left" style="margin-left: 40px">
    <button type="button" class="btn btn-info" style="width: 100px" onclick="check();">Войти</button>
  </div>
</div>


</body>

</html>
