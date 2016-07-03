<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true"%> 
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>${fns:getConfig('productName')}</title>
	<meta name="decorator" content="blank"/>
    <link rel="Stylesheet" href="${ctxStatic}/jerichotab/css/jquery.jerichotab.css" />
    <script type="text/javascript" src="${ctxStatic}/jerichotab/js/jquery.jerichotab.js"></script>
	<style type="text/css">
		#main {padding:0;margin:0;} #main .container-fluid{padding:0 4px 0 6px;}
		#header {margin:0 0 8px;position:static;} #header li {font-size:14px;_font-size:12px;}
		#header .brand {font-family:Helvetica, Georgia, Arial, sans-serif, 黑体;font-size:26px;padding-left:33px;}
		#footer {margin:8px 0 0 0;padding:3px 0 0 0;font-size:11px;text-align:center;border-top:1px solid;}
		#footer, #footer a {color:#999;} #left{overflow-x:hidden;overflow-y:auto;}
		#userControl>li>a{text-shadow:none;} #userControl>li>a:hover, #user #userControl>li.open>a{background:transparent;}
		#mainFrame{overflow:visible;border:0;width:100%;height:650;}
	</style>
</head>
<body>
	<div id="main">
		<div id="header" class="navbar navbar-inverse navbar-fixed-top">
			<div class="navbar-inner">
				<div class="brand"><span id="productName">${fns:getConfig('productName')}</span></div>
				<ul id="userControl" class="nav pull-right">
					<li id="userInfo" class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#">您好, ${fns:getUser().name}</a>
						<ul class="dropdown-menu">
							<li><a href="${ctx}/sys/user/info" target="mainFrame">个人信息</a></li>
							<li><a href="${ctx}/sys/user/modifyPwd" target="mainFrame">修改密码</a></li>
						</ul>
					</li>
					<li><a href="${ctx}/logout">退出</a></li>
				</ul>
				<div class="nav-collapse">
					<ul id="menu" class="nav">
						<c:forEach items="${fns:getMenuList()}" var="menu" varStatus="idxStatus">
							<c:if test="${menu.parent.id eq '1'&&menu.isShow eq '1'}">
								<li class="menu ${idxStatus.index == 0 ? ' active' : ''}">
									<c:if test="${empty menu.href}">
										<a class="menu" href="javascript:;" data-href="${ctx}/sys/menu/tree?parentId=${menu.id}" data-id="${menu.id}"><span>${menu.name}</span></a>
									</c:if>
									<c:if test="${not empty menu.href}">
										<a class="menu" href="${fn:indexOf(menu.href, '://') eq -1 ? ctx : ''}${menu.href}" data-id="${menu.id}" target="mainFrame"><span>${menu.name}</span></a>
									</c:if>
								</li>
							</c:if>
						</c:forEach>
					</ul>
				</div>
			</div>
	    </div>
	    <div class="container-fluid">
			<div id="content" class="row-fluid">
				<div id="left"></div>
				<div id="openClose" class="close">&nbsp;</div>
				<div id="right">
					<iframe id="mainFrame" name="mainFrame" src=""></iframe>
				</div>
			</div>
		    <div id="footer" class="row-fluid">
	            Copyright &copy; ${fns:getConfig('copyrightYear')} <a href="javascript:void(0);">${fns:getConfig('productName')}</a> - Powered By <a href="javascript:void(0);" target="_blank">${fns:getConfig('author')}</a> ${fns:getConfig('version')}
			</div>
		</div>
	</div>
	<script type="text/javascript"> 
		$(document).ready(function() {
			$.fn.initJerichoTab({
	            renderTo: '#right', uniqueId: 'jerichotab',
	            contentCss: { 'height': $('#right').height() - tabTitleHeight },
	            tabs: [], loadOnce: true, tabWidth: 110, titleHeight: tabTitleHeight
	        });
			// 绑定菜单单击事件
			$("#menu a.menu").click(function(){
				// 一级菜单焦点
				$("#menu li.menu").removeClass("active");
				$(this).parent().addClass("active");
				// 左侧区域隐藏
				if ($(this).attr("target") == "mainFrame"){
					$("#left,#openClose").hide();
					wSizeWidth();
					$(".jericho_tab").hide();
					$("#mainFrame").show();
					return true;
				}
				// 左侧区域显示
				$("#left,#openClose").show();
				if(!$("#openClose").hasClass("close")){
					$("#openClose").click();
				}
				// 显示二级菜单
				var menuId = "#menu-" + $(this).attr("data-id");
				console.log($(menuId))
				if ($(menuId).length > 0){
					$("#left .accordion").hide();
					$(menuId).show();
					// 初始化点击第一个二级菜单
					if (!$(menuId + " .accordion-body:first").hasClass('in')){
						$(menuId + " .accordion-heading:first a").click();
					}
					if (!$(menuId + " .accordion-body li:first ul:first").is(":visible")){
						$(menuId + " .accordion-body a:first i").click();
					}
					// 初始化点击第一个三级菜单
					$(menuId + " .accordion-body li:first li:first a:first i").click();
				}else{
					// 获取二级菜单数据
					$.get($(this).attr("data-href"), function(data){
						console.log(data)
						if (data.indexOf("id=\"loginForm\"") != -1){
							alert('未登录或登录超时。请重新登录，谢谢！');
							top.location = "${ctx}";
							return false;
						}
						$("#left .accordion").hide();
						$("#left").append(data);
						// 链接去掉虚框
						$(menuId + " a").bind("focus",function() {
							if(this.blur) {this.blur()};
						});
						// 二级标题
						$(menuId + " .accordion-heading a").click(function(){
							$(menuId + " .accordion-toggle i").removeClass('icon-chevron-down').addClass('icon-chevron-right');
							if(!$($(this).attr('data-href')).hasClass('in')){
								$(this).children("i").removeClass('icon-chevron-right').addClass('icon-chevron-down');
							}
						});
						// 二级内容
						$(menuId + " .accordion-body a").click(function(){
							$(menuId + " li").removeClass("active");
							$(menuId + " li i").removeClass("icon-white");
							$(this).parent().addClass("active");
							$(this).children("i").addClass("icon-white");
						});
						// 展现三级
						$(menuId + " .accordion-inner a").click(function(){
							var href = $(this).attr("data-href");
							if($(href).length > 0){
								$(href).toggle().parent().toggle();
								return false;
							}
							return addTab($(this));
						});
						// 默认选中第一个菜单
						$(menuId + " .accordion-body a:first i").click();
						$(menuId + " .accordion-body li:first li:first a:first i").click();
					});
				}
				// 大小宽度调整
				wSizeWidth();
				return false;
			});
			// 初始化点击第一个一级菜单
			$("#menu a.menu:first span").click();
			$("#userInfo .dropdown-menu a").mouseup(function(){
				return addTab($(this), true);
			});
		});
		function addTab($this, refresh){
			$(".jericho_tab").show();
			$("#mainFrame").hide();
			$.fn.jerichoTab.addTab({
	            tabFirer: $this,
	            title: $this.text(),
	            closeable: true,
	            data: {
	                dataType: 'iframe',
	                dataLink: $this.attr('href')
	            }
	        }).loadData(refresh);
			return false;
		}
		var leftWidth = 160; // 左侧窗口大小
		var tabTitleHeight = 33; // 页签的高度
		var htmlObj = $("html"), mainObj = $("#main");
		var headerObj = $("#header"), footerObj = $("#footer");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize(){
			var minHeight = 500, minWidth = 980;
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":strs[1] < minWidth ? "auto" : "hidden", "overflow-y":strs[0] < minHeight ? "auto" : "hidden"});
			mainObj.css("width",strs[1] < minWidth ? minWidth - 10 : "auto");
			frameObj.height((strs[0] < minHeight ? minHeight : strs[0]) - headerObj.height() - footerObj.height() - (strs[1] < minWidth ? 42 : 28));
			$("#openClose").height($("#openClose").height() - 5);
			$(".jericho_tab iframe").height($("#right").height() - tabTitleHeight);
			wSizeWidth();
		}
		function wSizeWidth(){
			if (!$("#openClose").is(":hidden")){
				var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
				$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -5);
			}else{
				$("#right").width("100%");
			}
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>