package com.liferay.commerce.demo.request.quote.product.renderer.configuration;

import aQute.bnd.annotation.metatype.Meta;
import com.liferay.portal.configuration.metatype.annotations.ExtendedObjectClassDefinition;

@ExtendedObjectClassDefinition(
        category = "request-quote-renderer",
        scope = ExtendedObjectClassDefinition.Scope.GROUP
)
@Meta.OCD(
        id = "com.liferay.commerce.demo.request.quote.product.renderer.configuration.RequestQuoteRendererConfiguration",
        localization = "content/Language", name = "request-quote-renderer-configuration-name"
)
public interface RequestQuoteRendererConfiguration {
    @Meta.AD(
            deflt = "request-a-quote", description = "request-a-quote-page",
            name = "request-a-quote-page-name", required = false
    )
    public String requestQuotePage();

    @Meta.AD(
            deflt = "request-a-quote", description = "request-a-quote-caption",
            name = "request-a-quote-caption-name", required = false
    )
    public String requestQuoteCaption();
}
