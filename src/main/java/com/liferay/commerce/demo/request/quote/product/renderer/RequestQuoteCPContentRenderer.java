package com.liferay.commerce.demo.request.quote.product.renderer;

import com.liferay.commerce.demo.request.quote.product.renderer.configuration.RequestQuoteRendererConfiguration;
import com.liferay.commerce.price.CommerceProductPriceCalculation;
import com.liferay.commerce.product.catalog.CPCatalogEntry;
import com.liferay.commerce.product.content.render.CPContentRenderer;
import com.liferay.frontend.taglib.servlet.taglib.util.JSPRenderer;
import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ResourceBundleUtil;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Jeff Handa
 */
@Component(
        configurationPid = "com.liferay.commerce.demo.request.quote.product.renderer.configuration.RequestQuoteRendererConfiguration",
        immediate = true,
        property = {
                "commerce.product.content.renderer.key=" + RequestQuoteCPContentRenderer.KEY,
                "commerce.product.content.renderer.type=grouped",
                "commerce.product.content.renderer.type=simple",
                "commerce.product.content.renderer.type=virtual"
        },
        service = CPContentRenderer.class
)
public class RequestQuoteCPContentRenderer implements CPContentRenderer {

    public static final String KEY = "request-quote";

    @Override
    public String getKey() {
        return KEY;
    }

    @Override
    public String getLabel(Locale locale) {
        ResourceBundle resourceBundle = ResourceBundleUtil.getBundle(
                "content.Language", locale, getClass());

        return LanguageUtil.get(resourceBundle, "request-quote-renderer");
    }

    @Override
    public void render(CPCatalogEntry cpCatalogEntry, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

        httpServletRequest.setAttribute("commerceProductPriceCalculation", _commerceProductPriceCalculation);
        httpServletRequest.setAttribute(RequestQuoteRendererConfiguration.class.getName(), _configuration);
        _jspRenderer.renderJSP(
                _servletContext, httpServletRequest, httpServletResponse,
                "/render/view.jsp");
    }

    @Activate
    @Modified
    protected void activate(Map<String, Object> properties) {
        _configuration = ConfigurableUtil.createConfigurable(
                RequestQuoteRendererConfiguration.class, properties);
    }
    private volatile RequestQuoteRendererConfiguration _configuration;

    private static final Log _log = LogFactoryUtil.getLog(
            RequestQuoteCPContentRenderer.class);

    @Reference(
            target = "(osgi.web.symbolicname=com.liferay.commerce.demo.request.quote.product.renderer)"
    )
    private ServletContext _servletContext;

    @Reference
    private JSPRenderer _jspRenderer;

    @Reference
    private CommerceProductPriceCalculation _commerceProductPriceCalculation;
}