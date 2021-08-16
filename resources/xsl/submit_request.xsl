<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  
  <xsl:output method="xml" encoding="UTF-8" />
  <xsl:param name="MCR.mir-module.EditorMail" />
  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="MIR.UploadForm.path" />
  
  <xsl:template match="/contactMail">
    <xsl:if test="approvement='true'">
      <email>
        <from><xsl:value-of select="concat(to_name, '&lt;', to_mail, '&gt;')"/></from>
        <to><xsl:value-of select="$MCR.mir-module.EditorMail" /></to>
        <xsl:choose>
          <xsl:when test="copy_to_sender='true'">
            <bcc><xsl:value-of select="concat(to_name, '&lt;', to_mail, '&gt;')"/></bcc>
          </xsl:when>
          <xsl:otherwise>
            <bcc></bcc>
          </xsl:otherwise>
        </xsl:choose>
        <subject><xsl:value-of select="concat('[IPU - Publikationsserver] Neue Einreichung - ', title_de)" /></subject>
        <body>
          <xsl:value-of select="to_name" /> sendet folgende Publikation zur Einreichung:


  Angaben zur Person:
  -------------------
    Name:        <xsl:value-of select="to_name" />
    E-Mail:      <xsl:value-of select="to_mail" />
    Universität: <xsl:value-of select="university" />
    Fachbereich: <xsl:value-of select="department" />


  Angaben zur Publikation:
  ------------------------
    Titel (deutsch):            <xsl:value-of select="title_de" />
    Titel (englisch):           <xsl:value-of select="title_en" />
    Lizenz:                     <xsl:value-of select="license" />
    Schlagworte (deutsch):      <xsl:value-of select="keywords_de" />
    Schlagworte (englisch):     <xsl:value-of select="keywords_en" />
    Zusammenfassung (deutsch):  <xsl:value-of select="abstract_de" />
    Zusammenfassung (englisch): <xsl:value-of select="abstract_en" />
    Anmerkungen:                <xsl:value-of select="notes" />
            
        </body>
        <part>
          <xsl:value-of select="concat('file://', $MIR.UploadForm.path, '/', file/@name )" />
        </part>
      </email>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
