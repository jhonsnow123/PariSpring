package org.isouland.modules.sys.listener;

import javax.servlet.ServletContext;

import org.isouland.common.config.Global;
import org.springframework.web.context.WebApplicationContext;

public class WebContextListener extends org.springframework.web.context.ContextLoaderListener {
	
	@Override
	public WebApplicationContext initWebApplicationContext(ServletContext servletContext) {
		// 项目启动提示信息
		StringBuilder sb = new StringBuilder();
		sb.append("\r\n╔══════════════════════════════════════════════════════╗\r\n");
		sb.append("\r\n    欢迎使用 "+Global.getConfig("productName"));
		sb.append("        ☺ powered by "+Global.getConfig("author")+"\r\n");
		sb.append("\r\n╚══════════════════════════════════════════════════════╝\r\n");
		System.out.println(sb.toString());
		return super.initWebApplicationContext(servletContext);
	}
}
