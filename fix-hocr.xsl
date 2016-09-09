<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- use on hocr file to fix for hocr2pdf 0.8.9 textbox placement -->
<xsl:template match="/html">
   <xsl:text>&#13;</xsl:text>
   <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
</xsl:template>
<xsl:template match="node()|@*">
   <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
</xsl:template>
<xsl:template match="span[@class='ocr_line']">
   <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
   <xsl:element name="br">&#13;</xsl:element>
</xsl:template>
</xsl:stylesheet>
