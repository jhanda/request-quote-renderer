<%@ include file="/META-INF/resources/init.jsp" %>

<%
	CPContentHelper cpContentHelper = (CPContentHelper)request.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
	RequestQuoteRendererConfiguration requestQuoteRendererConfiguration = (RequestQuoteRendererConfiguration) GetterUtil.getObject(request.getAttribute(RequestQuoteRendererConfiguration.class.getName()));
	CommerceContext commerceContext = (CommerceContext)request.getAttribute(CommerceWebKeys.COMMERCE_CONTEXT);
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

	CommerceProductPriceCalculation commerceProductPriceCalculation = (CommerceProductPriceCalculation)request.getAttribute("commerceProductPriceCalculation");

	CPCatalogEntry cpCatalogEntry = cpContentHelper.getCPCatalogEntry(request);

	CPSku cpSku = cpContentHelper.getDefaultCPSku(cpCatalogEntry);

	long cpDefinitionId = cpCatalogEntry.getCPDefinitionId();

	String addToCartId = PortalUtil.generateRandomKey(request, "add-to-cart");

	CommerceMoney price = null;
	try {
		price = commerceProductPriceCalculation.getCPDefinitionMinimumPrice(cpDefinitionId, commerceContext);
	} catch (PortalException e) {
		e.printStackTrace();
	}
%>

<div class="mb-5 product-detail" id="<portlet:namespace /><%= cpDefinitionId %>ProductContent">
	<div class="row">
		<div class="col-md-6 col-xs-12">
			<commerce-ui:gallery CPDefinitionId="<%= cpDefinitionId %>" />
		</div>

		<div class="col-md-6 col-xs-12">
			<header class="product-header">
				<commerce-ui:compare-checkbox
						CPCatalogEntry="<%= cpCatalogEntry %>"
				/>

				<h3 class="product-header-tagline" data-text-cp-instance-sku>
					<%= (cpSku == null) ? StringPool.BLANK : HtmlUtil.escape(cpSku.getSku()) %>
				</h3>

				<h2 class="product-header-title"><%= HtmlUtil.escape(cpCatalogEntry.getName()) %></h2>

				<h4 class="product-header-subtitle" data-text-cp-instance-manufacturer-part-number>
					<%= (cpSku == null) ? StringPool.BLANK : HtmlUtil.escape(cpSku.getManufacturerPartNumber()) %>
				</h4>

				<h4 class="product-header-subtitle" data-text-cp-instance-gtin>
					<%= (cpSku == null) ? StringPool.BLANK : HtmlUtil.escape(cpSku.getGtin()) %>
				</h4>
			</header>

			<p class="mt-3 product-description"><%= cpCatalogEntry.getDescription() %></p>

			<h4 class="commerce-subscription-info mt-3 w-100">
				<c:if test="<%= cpSku != null %>">
					<commerce-ui:product-subscription-info
							CPInstanceId="<%= cpSku.getCPInstanceId() %>"
					/>
				</c:if>

				<span data-text-cp-instance-subscription-info></span>
				<span data-text-cp-instance-delivery-subscription-info></span>
			</h4>

			<div class="product-detail-options">
				<%@ include file="/render/form_handlers/aui.jspf" %>

				<%= cpContentHelper.renderOptions(renderRequest, renderResponse) %>

				<%@ include file="/render/form_handlers/metal_js.jspf" %>
			</div>

			<%--  Availability--%>
			<c:choose>
				<c:when test="<%= cpSku != null %>">
					<div class="availability mt-1"><%= cpContentHelper.getAvailabilityLabel(request) %></div>
					<div class="availability-estimate mt-1"><%= cpContentHelper.getAvailabilityEstimateLabel(request) %></div>
					<div class="mt-1 stock-quantity"><%= cpContentHelper.getStockQuantityLabel(request) %></div>
				</c:when>
				<c:otherwise>
					<div class="availability mt-1" data-text-cp-instance-availability></div>
					<div class="availability-estimate mt-1" data-text-cp-instance-availability-estimate></div>
					<div class="stock-quantity mt-1" data-text-cp-instance-stock-quantity></div>
				</c:otherwise>
			</c:choose>

			<%-- Pricing --%>
			<c:choose>
				<c:when test="<%= cpSku != null && price.getPrice().intValue() == 0 %>">
					<div class="minium-card__price" style="text-align: center;">
						<div>
							<a class="commerce-button commerce-button--outline w-50"
							   href="<%= requestQuoteUrl %>"><liferay-ui:message key="<%= requestQuoteCaption%>" />
							</a>
						</div>
						<div>&nbsp;</div>
					</div>
				</c:when>
				<c:otherwise>
					<h2 class="commerce-price mt-3" data-text-cp-instance-price>
						<commerce-ui:price
								CPCatalogEntry="<%= cpCatalogEntry %>"
						/>
					</h2>

					<c:if test="<%= cpSku != null %>">
						<liferay-commerce:tier-price
								CPInstanceId="<%= cpSku.getCPInstanceId() %>"
								taglibQuantityInputId='<%= renderResponse.getNamespace() + cpDefinitionId + "Quantity" %>'
						/>
					</c:if>

					<div class="mt-3 product-detail-actions">
						<div class="autofit-col"
							 id="<%= addToCartId %>">
							<commerce-ui:add-to-cart
									CPCatalogEntry="<%= cpCatalogEntry %>"
									namespace="<%= liferayPortletResponse.getNamespace() %>"
									skuOptions='<%= "[]" %>'
							/>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<%
	List<CPDefinitionSpecificationOptionValue> cpDefinitionSpecificationOptionValues = cpContentHelper.getCPDefinitionSpecificationOptionValues(cpDefinitionId);
	List<CPOptionCategory> cpOptionCategories = cpContentHelper.getCPOptionCategories(company.getCompanyId());
	List<CPMedia> cpAttachmentFileEntries = cpContentHelper.getCPMedias(cpDefinitionId, themeDisplay);
%>

<c:if test="<%= cpContentHelper.hasCPDefinitionSpecificationOptionValues(cpDefinitionId) %>">
	<commerce-ui:panel
			elementClasses="flex-column mb-3"
			title='<%= LanguageUtil.get(resourceBundle, "specifications") %>'
	>
		<dl class="specification-list">

			<%
				for (CPDefinitionSpecificationOptionValue cpDefinitionSpecificationOptionValue : cpDefinitionSpecificationOptionValues) {
					CPSpecificationOption cpSpecificationOption = cpDefinitionSpecificationOptionValue.getCPSpecificationOption();
			%>

			<dt class="specification-term">
				<%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %>
			</dt>
			<dd class="specification-desc">
				<%= HtmlUtil.escape(cpDefinitionSpecificationOptionValue.getValue(languageId)) %>
			</dd>

			<%
				}

				for (CPOptionCategory cpOptionCategory : cpOptionCategories) {
					List<CPDefinitionSpecificationOptionValue> categorizedCPDefinitionSpecificationOptionValues = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, cpOptionCategory.getCPOptionCategoryId());
			%>

			<c:if test="<%= !categorizedCPDefinitionSpecificationOptionValues.isEmpty() %>">

				<%
					for (CPDefinitionSpecificationOptionValue cpDefinitionSpecificationOptionValue : categorizedCPDefinitionSpecificationOptionValues) {
						CPSpecificationOption cpSpecificationOption = cpDefinitionSpecificationOptionValue.getCPSpecificationOption();
				%>

				<dt class="specification-term">
					<%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %>
				</dt>
				<dd class="specification-desc">
					<%= HtmlUtil.escape(cpDefinitionSpecificationOptionValue.getValue(languageId)) %>
				</dd>

				<%
					}
				%>

			</c:if>

			<%
				}
			%>

		</dl>
	</commerce-ui:panel>
</c:if>

<c:if test="<%= !cpAttachmentFileEntries.isEmpty() %>">
	<commerce-ui:panel
			elementClasses="mb-3"
			title='<%= LanguageUtil.get(resourceBundle, "attachments") %>'
	>
		<dl class="specification-list">

			<%
				int attachmentsCount = 0;

				for (CPMedia curCPAttachmentFileEntry : cpAttachmentFileEntries) {
			%>

			<dt class="specification-term">
				<%= HtmlUtil.escape(curCPAttachmentFileEntry.getTitle()) %>
			</dt>
			<dd class="specification-desc">
				<aui:icon cssClass="icon-monospaced" image="download" markupView="lexicon" target="_blank" url="<%= curCPAttachmentFileEntry.getDownloadURL() %>" />
			</dd>

			<%
				attachmentsCount = attachmentsCount + 1;
			%>

			<c:if test="<%= attachmentsCount >= 2 %>">
				<dt class="specification-empty specification-term"></dt>
				<dd class="specification-desc specification-empty"></dd>

				<%
					attachmentsCount = 0;
				%>

			</c:if>

			<%
				}
			%>

		</dl>
	</commerce-ui:panel>
</c:if>