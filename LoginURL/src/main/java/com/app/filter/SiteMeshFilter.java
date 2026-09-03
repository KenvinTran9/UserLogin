package com.app.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;

import java.io.CharArrayWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

/**
 * Custom decorator filter (replaces SiteMesh which is incompatible with Jakarta Servlet API).
 * Captures page output and decorates it with the main layout template.
 */
@WebFilter(filterName = "SiteMeshFilter", urlPatterns = {"/*"})
public class SiteMeshFilter implements Filter {

    private static final String DECORATOR_PATH = "/views/decorator/main-layout.jsp";

    // Paths to EXCLUDE from decoration (no layout wrapper)
    private static final List<String> EXCLUDE_PATHS = Arrays.asList(
            "/login", "/error", "/logout"
    );

    // Resource extensions to skip
    private static final List<String> SKIP_EXTENSIONS = Arrays.asList(
            ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".svg", ".woff", ".woff2", ".ttf"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getServletPath();
        String contextPath = httpRequest.getContextPath();

        // Skip static resources
        for (String ext : SKIP_EXTENSIONS) {
            if (path.endsWith(ext)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Skip uploads
        if (path.startsWith("/uploads")) {
            chain.doFilter(request, response);
            return;
        }

        // Skip excluded paths (login, error, logout)
        for (String excludePath : EXCLUDE_PATHS) {
            if (path.equals(excludePath)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Skip if not logged in (let servlets handle redirect)
        if (httpRequest.getSession(false) == null ||
                httpRequest.getSession(false).getAttribute("user") == null) {
            chain.doFilter(request, response);
            return;
        }

        // Wrap response to capture output
        CharArrayWriter charWriter = new CharArrayWriter();
        HttpServletResponse wrappedResponse = new HttpServletResponseWrapper(httpResponse) {
            private PrintWriter writer = new PrintWriter(charWriter);

            @Override
            public PrintWriter getWriter() {
                return writer;
            }

            @Override
            public void setContentType(String type) {
                super.setContentType(type);
            }
        };

        // Execute the original servlet/JSP
        chain.doFilter(request, wrappedResponse);

        // Check if it was a redirect (no content to decorate)
        if (wrappedResponse.getStatus() == 302 || wrappedResponse.getStatus() == 301) {
            return;
        }

        String originalContent = charWriter.toString();

        // If empty content, pass through
        if (originalContent.isEmpty()) {
            return;
        }

        // Extract title, head content, and body content
        String title = extractBetween(originalContent, "<title>", "</title>");
        String headContent = extractBetween(originalContent, "<head>", "</head>");
        String bodyContent = extractBetween(originalContent, "<body>", "</body>");

        // If can't parse, output original
        if (bodyContent == null) {
            httpResponse.getWriter().write(originalContent);
            return;
        }

        // Remove <title> and <link> to style.css from head (decorator provides these)
        if (headContent != null) {
            headContent = headContent.replaceAll("<title>.*?</title>", "");
            headContent = headContent.replaceAll("<meta[^>]*>", "");
            headContent = headContent.replaceAll("<link[^>]*style\\.css[^>]*>", "");
            headContent = headContent.trim();
        }

        // Set attributes for decorator JSP
        httpRequest.setAttribute("_decorator_title", title != null ? title : "LoginURL");
        httpRequest.setAttribute("_decorator_head", headContent != null ? headContent : "");
        httpRequest.setAttribute("_decorator_body", bodyContent);

        // Forward to decorator
        httpResponse.setContentType("text/html;charset=UTF-8");
        RequestDispatcher dispatcher = httpRequest.getRequestDispatcher(DECORATOR_PATH);
        dispatcher.forward(httpRequest, httpResponse);
    }

    /**
     * Extract content between two tags (case-insensitive for tag matching).
     */
    private String extractBetween(String content, String startTag, String endTag) {
        String lowerContent = content.toLowerCase();
        String lowerStartTag = startTag.toLowerCase();
        String lowerEndTag = endTag.toLowerCase();

        int startIdx = lowerContent.indexOf(lowerStartTag);
        if (startIdx == -1) return null;

        startIdx += startTag.length();
        int endIdx = lowerContent.indexOf(lowerEndTag, startIdx);
        if (endIdx == -1) return null;

        return content.substring(startIdx, endIdx);
    }

    @Override
    public void destroy() {
    }
}
