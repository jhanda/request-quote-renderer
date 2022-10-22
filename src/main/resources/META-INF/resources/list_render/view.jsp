<%@ include file="/META-INF/resources/init.jsp" %>

<%
    CPContentHelper cpContentHelper = (CPContentHelper) request.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
    CPDataSourceResult cpDataSourceResult = (CPDataSourceResult) request.getAttribute(CPWebKeys.CP_DATA_SOURCE_RESULT);
%>

<c:choose>
    <c:when test="<%= !cpDataSourceResult.getCPCatalogEntries().isEmpty() %>">
        <div class="product-card-tiles">
            <%
                for (CPCatalogEntry cpCatalogEntry : cpDataSourceResult.getCPCatalogEntries()) {
                    CPSku cpSku = cpContentHelper.getDefaultCPSku(cpCatalogEntry);
                    String addToCartId = PortalUtil.generateRandomKey(request, "add-to-cart");
                    String productDetailURL = cpContentHelper.getFriendlyURL(cpCatalogEntry, themeDisplay);
                    RequestQuoteRendererConfiguration requestQuoteRendererConfiguration =
                            (RequestQuoteRendererConfiguration) GetterUtil.getObject(request.getAttribute(
                                    RequestQuoteRendererConfiguration.class.getName()));
                    boolean isPublic = themeDisplay.getLayout().isPublicLayout();
                    String groupName = themeDisplay.getSiteGroupName().toLowerCase();
                    String requestQuotePage = requestQuoteRendererConfiguration.requestQuotePage();
                    String requestQuoteUrl = "";
                    if (isPublic) {
                        requestQuoteUrl = "/web/" + groupName + "/" + requestQuotePage;
                    } else {
                        requestQuoteUrl = "/group/" + groupName + "/" + requestQuotePage;
                    }
                    String requestQuoteCaption = requestQuoteRendererConfiguration.requestQuoteCaption();
                    CommerceContext commerceContext = (CommerceContext) request.getAttribute(
                            CommerceWebKeys.COMMERCE_CONTEXT);
                    CommerceProductPriceCalculation commerceProductPriceCalculation = (CommerceProductPriceCalculation) request.getAttribute(
                            "commerceProductPriceCalculation");
                    CommerceMoney price = null;
                    try {
                        price = commerceProductPriceCalculation.getCPDefinitionMinimumPrice(
                                cpCatalogEntry.getCPDefinitionId(), commerceContext);
                    } catch (PortalException e) {
                        e.printStackTrace();
                    }
            %>
            <div class="cp-renderer">
                <div class="card d-flex flex-column product-card">
                    <div class="card-item-first position-relative">
                        <a href="<%= productDetailURL %>">
                            <liferay-adaptive-media:img
                                    class="img-fluid product-card-picture"
                                    fileVersion="<%= cpContentHelper.getCPDefinitionImageFileVersion(cpCatalogEntry.getCPDefinitionId(), request) %>"
                            />

                            <div class="aspect-ratio-item-bottom-left">
                                <commerce-ui:availability-label
                                        CPCatalogEntry="<%= cpCatalogEntry %>"
                                />
                            </div>
                        </a>
                    </div>

                    <div class="card-body d-flex flex-column justify-content-between py-2">
                        <div class="cp-information">
                            <p class="card-subtitle"
                               title="<%= (cpSku == null) ? StringPool.BLANK : cpSku.getSku() %>">
                                <span class="text-truncate-inline">
                                <span class="text-truncate">
                                    <%= (cpSku == null) ? StringPool.BLANK
                                                        : cpSku.getSku() %></span>
                                </span>
                            </p>

                            <p class="card-title" title="<%= cpCatalogEntry.getName() %>">
                                <a href="<%= productDetailURL %>">
                                <span class="text-truncate-inline">
                                    <span class="text-truncate"><%= cpCatalogEntry.getName() %></span>
                                </span>
                                </a>
                            </p>
                            <c:choose>
                                <c:when test="<%= cpSku != null   && price.getPrice().intValue() > 0%>">
                                    <p class="card-text">
                                        <span class="text-truncate-inline">
                                            <span class="d-flex flex-row text-truncate">
                                                <commerce-ui:price
                                                        compact="<%= true %>"
                                                        CPCatalogEntry="<%= cpCatalogEntry %>"
                                                />
                                            </span>
                                        </span>
                                    </p>
                                </c:when>
                                <c:otherwise/>
                            </c:choose>
                        </div>

                        <div>
                            <c:choose>
                                <c:when test="<%= cpSku != null   && price.getPrice().intValue() == 0%>">

                                    <div class="add-to-cart d-flex my-2 pt-5"
                                         id="<%= addToCartId %>">
                                        <a class="btn btn-block btn-secondary"
                                           href="<%= requestQuoteUrl %>" role="button"
                                           style="margin-top: 0.35rem;">
                                            <liferay-ui:message key="<%= requestQuoteCaption%>"/>
                                        </a>
                                    </div>

                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="<%= (cpSku == null) || cpContentHelper.hasCPDefinitionOptionRels(cpCatalogEntry.getCPDefinitionId()) %>">
                                            <div class="add-to-cart d-flex my-2 pt-5"
                                                 id="<%= addToCartId %>">
                                                <a class="btn btn-block btn-secondary"
                                                   href="<%= productDetailURL %>" role="button"
                                                   style="margin-top: 0.35rem;">
                                                    <liferay-ui:message key="view-all-variants"/>
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="<%= addToCartId %>">
                                                <commerce-ui:add-to-cart CPCatalogEntry="<%= cpCatalogEntry %>"/>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>

                            <div class="autofit-float autofit-row autofit-row-center compare-wishlist">
                                <div class="autofit-col autofit-col-expand compare-checkbox">
                                    <div class="autofit-section">
                                        <div class="custom-checkbox custom-control custom-control-primary">
                                            <div class="custom-checkbox custom-control">
                                                <commerce-ui:compare-checkbox
                                                        CPCatalogEntry="<%= cpCatalogEntry %>"
                                                        label='<%= LanguageUtil.get(request, "compare") %>'
                                                />
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="autofit-col">
                                    <div class="autofit-section">
                                        <commerce-ui:add-to-wish-list
                                                CPCatalogEntry="<%= cpCatalogEntry %>"
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
    </c:when>
    <c:otherwise>
        <div class="alert alert-info">
            <liferay-ui:message key="no-products-were-found"/>
        </div>
    </c:otherwise>
</c:choose>
