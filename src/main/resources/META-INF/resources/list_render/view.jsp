<%@ page import="com.liferay.commerce.demo.request.quote.product.renderer.list.RequestQuoteCPContentListRenderer" %>
<%@ include file="/META-INF/resources/init.jsp" %>

<%
    CPContentHelper cpContentHelper = (CPContentHelper)request.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
    CPDataSourceResult cpDataSourceResult = (CPDataSourceResult)request.getAttribute(CPWebKeys.CP_DATA_SOURCE_RESULT);
    RequestQuoteRendererConfiguration requestQuoteRendererConfiguration = (RequestQuoteRendererConfiguration) GetterUtil.getObject(request.getAttribute(RequestQuoteRendererConfiguration.class.getName()));
    boolean isPublic = themeDisplay.getLayout().isPublicLayout();
    String groupName = themeDisplay.getSiteGroupName().toLowerCase();
    String requestQuotePage = requestQuoteRendererConfiguration.requestQuotePage();
    String requestQuoteUrl ="";
    if (isPublic){
        requestQuoteUrl = "/web/" + groupName + "/" + requestQuotePage;
    }else{
        requestQuoteUrl = "/group/" + groupName + "/" + requestQuotePage;
    }
    String requestQuoteCaption = requestQuoteRendererConfiguration.requestQuoteCaption();
    List<CPCatalogEntry> cpCatalogEntries = cpDataSourceResult.getCPCatalogEntries();
    CommerceContext commerceContext = (CommerceContext)request.getAttribute(CommerceWebKeys.COMMERCE_CONTEXT);
    CommerceProductPriceCalculation commerceProductPriceCalculation = (CommerceProductPriceCalculation)request.getAttribute("commerceProductPriceCalculation");

%>
<c:choose>
    <c:when test="<%= !cpCatalogEntries.isEmpty() %>">
        <div class="minium-product-tiles">
            <%
                for (CPCatalogEntry cpCatalogEntry : cpCatalogEntries) {

                    String productFriendlyUrl = cpContentHelper.getFriendlyURL(cpCatalogEntry, themeDisplay);
                    String productDefaultImageUrl = cpCatalogEntry.getDefaultImageFileUrl();
                    CPSku cpSku = cpContentHelper.getDefaultCPSku(cpCatalogEntry);
                    String addToCartId = PortalUtil.generateRandomKey(request, "add-to-cart");
                    long cpDefinitionId = cpCatalogEntry.getCPDefinitionId();

                    CommerceMoney price = null;
                    try {
                        price = commerceProductPriceCalculation.getCPDefinitionMinimumPrice(cpDefinitionId, commerceContext);
                    } catch (PortalException e) {
                        e.printStackTrace();
                    }

            %>

            <div class="minium-product-tiles__item">
                <div class="minium-card product-card" data-href="<%= productFriendlyUrl %>>" data-onkeypress="_handleCardKeypress" id="ucsv" tabindex="0">
                    <div class="minium-card__compare">
                        <label class="product-compare-checkbox">
                            <input id="product-42594-compare-checkbox" class="product-compare-checkbox__input" type="checkbox" data-onchange="null">
                        </label>
                    </div>
                    <button data-onclick="null" class="minium-card__add-to-wishlist-button">
                        <svg class="lexicon-icon lexicon-icon-heart" focusable="false" role="presentation" viewBox="0 0 512 512">
                            <path d="M80.78 230.381l175.21 183.613 175.213-183.632c.112-.164.24-.314.355-.48 15.104-20.64 19.962-45.813 13.687-70.901-7.175-28.655-30.368-51.686-59.111-58.688-6.275-1.51-12.387-2.29-18.16-2.29-55.638 0-81.404 75.812-81.68 76.576-4.406 13.356-16.614 22.384-30.288 22.384h-.208c-13.769-.102-25.961-9.21-30.224-22.716-.192-.631-25.446-76.244-81.549-76.244-5.469 0-11.26.68-17.179 2.025-28.55 6.421-52.645 29.9-59.948 58.389-6.482 25.287-1.673 50.674 13.544 71.465.096.166.225.332.337.499zM255.99 480c-17.273 0-33.472-6.986-45.6-19.696L31.592 272.925a33.239 33.239 0 0 1-5.774-8.314C1.32 228.275-6.062 184.818 5.036 141.544c13.511-52.615 55.943-94.23 108.122-106.01C123.581 33.194 133.956 32 144.025 32c53.674 0 89.706 31.907 112.097 63.085C278.624 63.925 314.669 32 367.974 32c10.714 0 21.764 1.377 32.829 4.065 51.6 12.544 93.373 54.324 106.4 106.442 10.778 43.008 3.251 86.232-21.165 122.322a32.762 32.762 0 0 1-5.632 8.096L301.594 460.304C289.482 473.014 273.267 480 255.99 480z"></path>
                        </svg>
                        <svg class="lexicon-icon lexicon-icon-heart-full" focusable="false" role="presentation" viewBox="0 0 512 512">
                            <path fill-rule="evenodd" clip-rule="evenodd" d="M255.99 480c-17.273 0-33.472-6.986-45.6-19.696L31.592 272.925a33.239 33.239 0 0 1-5.774-8.314C1.32 228.275-6.062 184.818 5.036 141.544c13.511-52.615 55.943-94.23 108.122-106.01C123.581 33.194 133.956 32 144.025 32c53.674 0 89.706 31.907 112.097 63.085C278.624 63.925 314.669 32 367.974 32c10.714 0 21.764 1.377 32.829 4.065 51.6 12.544 93.373 54.324 106.4 106.442 10.778 43.008 3.251 86.232-21.165 122.322a32.762 32.762 0 0 1-5.632 8.096L301.594 460.304C289.482 473.014 273.267 480 255.99 480z"></path>
                        </svg>
                    </button>
                    <a class="minium-card__picture"
                       href="<%= productFriendlyUrl %>"
                       style="background-image: url(<%= productDefaultImageUrl %>)" tabindex="-1">
                    </a>
                    <div class="minium-card__availability">
                        <%--  TODO:  Fix this, it should not be hardcoded to good --%>
                        <div class="commerce-dot commerce-dot--big commerce-dot--good"></div>
                    </div>
                    <p class="minium-card__sku">
                        <%= (cpSku == null) ? StringPool.BLANK : HtmlUtil.escape(cpSku.getSku()) %>
                    </p>
                    <a class="minium-card__name" href="<%= productFriendlyUrl %>" tabindex="-1">
                        <%= HtmlUtil.escape(cpCatalogEntry.getName()) %>
                    </a>
                    <p class="minium-card__description">
                        <%= HtmlUtil.escape(cpCatalogEntry.getShortDescription())%>
                    </p>

                    <c:choose>
                        <c:when test="<%= cpSku != null   && price.getPrice().intValue() == 0%>">

                        <div class="minium-card__price">
                            <div>
                                <a class="commerce-button commerce-button--outline w-100"
                                   href="<%= requestQuoteUrl %>"><liferay-ui:message key="<%= requestQuoteCaption%>" />
                                </a>
                            </div>
                        </div>

                        </c:when>
                        <c:otherwise>
                            <div class="minium-card__price">
                                <commerce-ui:price
                                        CPDefinitionId="<%= cpCatalogEntry.getCPDefinitionId() %>"
                                        CPInstanceId="<%= (cpSku == null) ? 0 : cpSku.getCPInstanceId() %>"
                                />
                            </div>

                            <commerce-ui:add-to-cart
                                CPInstanceId="<%= (cpSku == null) ? 0 : cpSku.getCPInstanceId() %>"
                                id="<%= addToCartId %>"
                            />
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <%
                }
            %>
        </div>
        </c:when>
    <c:otherwise>
        <div class="alert alert-info">
            <liferay-ui:message key="no-products-were-found" />
        </div>
    </c:otherwise>
</c:choose>