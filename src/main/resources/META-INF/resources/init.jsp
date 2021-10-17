<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>

<%@ taglib uri="http://liferay.com/tld/commerce" prefix="liferay-commerce" %>
<%@ taglib uri="http://liferay.com/tld/commerce-product" prefix="liferay-commerce-product" %>

<%@ taglib uri="http://liferay.com/tld/commerce-ui" prefix="commerce-ui" %>

<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ResourceBundle" %>

<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>

<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>

<%@ page import="com.liferay.commerce.product.data.source.CPDataSourceResult" %>
<%@ page import="com.liferay.commerce.product.constants.CPWebKeys" %>
<%@ page import="com.liferay.commerce.product.catalog.CPCatalogEntry" %>
<%@ page import="com.liferay.commerce.product.catalog.CPSku" %>
<%@ page import="com.liferay.portal.kernel.util.PortalUtil" %>
<%@ page import="com.liferay.commerce.product.content.util.CPContentHelper" %>
<%@ page import="com.liferay.commerce.product.content.constants.CPContentWebKeys" %>

<%@ page import="com.liferay.petra.string.StringPool" %>

<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.commerce.product.model.CPDefinitionSpecificationOptionValue" %>
<%@ page import="com.liferay.commerce.product.model.CPOptionCategory" %>
<%@ page import="com.liferay.commerce.product.catalog.CPMedia" %>
<%@ page import="com.liferay.commerce.product.model.CPSpecificationOption" %>
<%@ page import="com.liferay.commerce.price.CommerceProductPriceCalculation" %>

<%@ page import="com.liferay.commerce.context.CommerceContext" %>
<%@ page import="com.liferay.commerce.constants.CommerceWebKeys" %>
<%@ page import="com.liferay.portal.kernel.exception.PortalException" %>
<%@ page import="com.liferay.commerce.currency.model.CommerceMoney" %>

<%@ page import="com.liferay.commerce.demo.request.quote.product.renderer.configuration.RequestQuoteRendererConfiguration" %>

<liferay-frontend:defineObjects />
<liferay-theme:defineObjects />
<portlet:defineObjects />
<%
	String languageId = LanguageUtil.getLanguageId(locale);
%>