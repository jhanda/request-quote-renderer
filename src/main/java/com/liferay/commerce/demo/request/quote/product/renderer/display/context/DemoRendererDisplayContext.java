package com.liferay.commerce.demo.request.quote.product.renderer.display.context;

import com.liferay.asset.kernel.model.AssetCategory;
import com.liferay.asset.kernel.model.AssetEntry;
import com.liferay.asset.kernel.service.AssetEntryLocalService;
import com.liferay.asset.kernel.service.AssetVocabularyLocalService;
import com.liferay.commerce.product.content.constants.CPContentWebKeys;
import com.liferay.commerce.product.content.util.CPContentHelper;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.model.CPDefinitionSpecificationOptionValue;
import com.liferay.commerce.product.model.CPSpecificationOption;
import com.liferay.commerce.product.service.CPDefinitionLocalService;
import com.liferay.commerce.product.service.CPDefinitionSpecificationOptionValueLocalService;
import com.liferay.commerce.product.service.CPOptionCategoryLocalService;
import com.liferay.commerce.product.service.CPSpecificationOptionLocalService;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.FastDateFormatFactoryUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.xml.Document;
import com.liferay.portal.kernel.xml.DocumentException;
import com.liferay.portal.kernel.xml.Element;
import com.liferay.portal.kernel.xml.SAXReaderUtil;

import javax.servlet.http.HttpServletRequest;
import java.text.DateFormat;
import java.text.Format;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author Jeff Handa
 */
public class DemoRendererDisplayContext {

    public DemoRendererDisplayContext(
            HttpServletRequest httpServletRequest, CPDefinitionLocalService cpDefinitionLocalService,
            CPOptionCategoryLocalService cpOptionCategoryLocalService,
            CPSpecificationOptionLocalService cpSpecificationOptionLocalService,
            CPDefinitionSpecificationOptionValueLocalService cpDefinitionSpecificationOptionValueLocalService,
            AssetEntryLocalService assetEntryLocalService, AssetVocabularyLocalService assetVocabularyLocalService) {

        this._themeDisplay = (ThemeDisplay) httpServletRequest.getAttribute(WebKeys.THEME_DISPLAY);
        this._companyId = _themeDisplay.getCompanyId();
        this._assetEntryLocalService = assetEntryLocalService;
        this._assetVocabularyLocalService = assetVocabularyLocalService;
        this._cpContentHelper = (CPContentHelper) httpServletRequest.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
        this._cpDefinitionLocalService = cpDefinitionLocalService;
        this._cpOptionCategoryLocalService = cpOptionCategoryLocalService;
        this._cpSpecificationOptionLocalService = cpSpecificationOptionLocalService;
        this._cpDefinitionSpecificationOptionValueLocalService = cpDefinitionSpecificationOptionValueLocalService;
        this._httpServletRequest = httpServletRequest;
    }

    public String getCreatedDateAsString(long cpDefinitionId) throws PortalException {

        CPDefinition cpDefinition = _cpDefinitionLocalService.getCPDefinition(cpDefinitionId);

        Format formatDate = FastDateFormatFactoryUtil.getDate(
                DateFormat.MEDIUM, _themeDisplay.getLocale(), _themeDisplay.getTimeZone());

        Date createDate = cpDefinition.getCreateDate();

        return formatDate.format(createDate);
    }

    public String getModifiedDateAsString(long cpDefinitionId) throws PortalException {

        CPDefinition cpDefinition = _cpDefinitionLocalService.getCPDefinition(cpDefinitionId);

        Format formatDate = FastDateFormatFactoryUtil.getDate(
                DateFormat.MEDIUM, _themeDisplay.getLocale(), _themeDisplay.getTimeZone());

        Date modifiedDate = cpDefinition.getModifiedDate();

        return formatDate.format(modifiedDate);
    }


    public String getSpecificationByKey(long cpDefinitionId, String specificationKey) throws PortalException, DocumentException {
        CPSpecificationOption cpSpecificationOption = _cpSpecificationOptionLocalService.getCPSpecificationOption(_companyId, specificationKey);
        List<CPDefinitionSpecificationOptionValue> values =
                _cpDefinitionSpecificationOptionValueLocalService.getCPDefinitionSpecificationOptionValuesByC_CSO(cpDefinitionId, cpSpecificationOption.getCPSpecificationOptionId());
        if (values.size() > 0) {
            Document document = SAXReaderUtil.read(values.get(0).getValue());
            Element rootElement = document.getRootElement();
            Element elementValue = rootElement.element("Value");
            return elementValue.getStringValue();

        } else {
            return "";
        }
    }

    public List<CPDefinitionSpecificationOptionValue> getSpecificationsByGroup(long cpDefinitionId, String specificationGroupKey) throws PortalException {
        List<CPDefinitionSpecificationOptionValue> specificationsByGroup = new ArrayList<>();
        long specificationCategoryId = getSpecificationCategoryId(specificationGroupKey);
        specificationsByGroup = _cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, specificationCategoryId);
        return specificationsByGroup;
    }

    private long getSpecificationCategoryId(String optionCategoryKey){

        return _cpOptionCategoryLocalService.fetchCPOptionCategory(_companyId, optionCategoryKey).getCPOptionCategoryId();

    }

    private long getAssetVocabularyIdByName(String name) {

        DynamicQuery dq = _assetVocabularyLocalService.dynamicQuery();
        dq.add(RestrictionsFactoryUtil.eq("name", name));
        dq.setProjection(PropertyFactoryUtil.forName("vocabularyId"));
        List<Long> vocabularyIds = _assetVocabularyLocalService.dynamicQuery(dq);
        return vocabularyIds.get(0);

    }

    private AssetEntry getAssetEntryByClassPk(long classPK) {

        DynamicQuery dq = _assetEntryLocalService.dynamicQuery();
        dq.add(RestrictionsFactoryUtil.eq("classPK", classPK));
        List<AssetEntry> assetEntries = _assetEntryLocalService.dynamicQuery(dq);
        return assetEntries.get(0);

    }

    public List getAssetCategoriesByVocabularyName(long cpDefinitionId, String name) throws PortalException {


        List<AssetCategory> assetCategoriesByName = new ArrayList<AssetCategory>();

        long vocabularyId = getAssetVocabularyIdByName(name);
        AssetEntry assetEntry = getAssetEntryByClassPk(cpDefinitionId);

        List<AssetCategory> assetCategories = assetEntry.getCategories();

        for (AssetCategory assetCategory : assetCategories) {
            if (assetCategory.getVocabularyId() == vocabularyId) {
                assetCategoriesByName.add(assetCategory);
            }
            ;
        }
        return assetCategoriesByName;
    }

    private static final Log _log = LogFactoryUtil.getLog(
            DemoRendererDisplayContext.class);

    private final long _companyId;
    private final AssetEntryLocalService _assetEntryLocalService;
    private final AssetVocabularyLocalService _assetVocabularyLocalService;
    private final CPContentHelper _cpContentHelper;
    private final CPDefinitionLocalService _cpDefinitionLocalService;
    private final CPDefinitionSpecificationOptionValueLocalService _cpDefinitionSpecificationOptionValueLocalService;
    private final CPOptionCategoryLocalService _cpOptionCategoryLocalService;
    private final CPSpecificationOptionLocalService _cpSpecificationOptionLocalService;
    private final HttpServletRequest _httpServletRequest;
    private final ThemeDisplay _themeDisplay;

}
