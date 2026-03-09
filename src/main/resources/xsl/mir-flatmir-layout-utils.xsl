<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:mcracl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mcri18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:mcrversion="xalan://org.mycore.common.MCRCoreVersion"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="date mcracl mcri18n mcrversion">

  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />
  <xsl:param name="MIR.TestInstance" />

  <xsl:template name="mir.navigation">
    <xsl:if test="contains($MIR.TestInstance, 'true')">
      <div id="watermark_testenvironment">Testumgebung</div>
    </xsl:if>
    <div id="header_box" class="clearfix container">
      <div id="options_nav_box" class="mir-prop-nav text-right">
        <nav>
          <ul class="navbar-nav ml-auto flex-row">
            <xsl:call-template name="mir.loginMenu" />
            <xsl:call-template name="mir.languageMenu" />
          </ul>
        </nav>
        <a href="https://www.ipu-berlin.de/bibliothek/" id="ipu-bibliothek">IPU Bibliothek</a>
      </div>
      <div id="project_logo_box">
        <a href="{$WebApplicationBaseURL}">
          <img src="{$WebApplicationBaseURL}images/OEDIPUB_Logo.svg" alt="Logo OEDIPUB" />
          <div>
            <span class="project-name">OED<strong>IPU</strong>B</span>
            <span class="project-slogen">Offene elektronische Dokumente der IPU Bibliothek</span>
          </div>
        </a>
      </div>
    </div>
    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="mir-main-nav">
      <div class="container">
        <nav class="navbar navbar-expand-lg navbar-light">
          <button
            class="navbar-toggler"
            type="button"
            data-toggle="collapse"
            data-target="#mir-main-nav-collapse-box"
            aria-controls="mir-main-nav-collapse-box"
            aria-expanded="false"
            aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div id="mir-main-nav-collapse-box" class="collapse navbar-collapse mir-main-nav__entries">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
              <xsl:call-template name="project.generate_single_menu_entry">
                <xsl:with-param name="menuID" select="'brand'" />
              </xsl:call-template>
              <xsl:for-each select="$loaded_navigation_xml/menu">
                <xsl:choose>
                  <!-- Ignore some menus, they are shown elsewhere in the layout -->
                  <xsl:when test="@id='main'" />
                  <xsl:when test="@id='brand'" />
                  <xsl:when test="@id='below'" />
                  <xsl:when test="@id='user'" />
                  <xsl:otherwise>
                    <xsl:apply-templates select="." />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <xsl:call-template name="mir.basketMenu" />
            </ul>
            <form
              action="{$WebApplicationBaseURL}servlets/solr/find"
              class="searchfield_box form-inline my-2 my-lg-0"
              role="search">
              <input
                name="condQuery"
                placeholder="{mcri18n:translate('mir.navsearch.placeholder')}"
                class="form-control mr-sm-2 search-query"
                id="searchInput"
                type="text"
                aria-label="Search" />
              <xsl:choose>
                <xsl:when test="contains($isSearchAllowedForCurrentUser, 'true')">
                  <input name="owner" type="hidden" value="createdby:*" />
                </xsl:when>
                <xsl:when test="not(mcracl:isCurrentUserGuestUser())">
                  <input name="owner" type="hidden" value="createdby:{$CurrentUser}" />
                </xsl:when>
              </xsl:choose>
              <button type="submit" class="btn btn-primary my-2 my-sm-0">
                <i class="fas fa-search"></i>
              </button>
            </form>
          </div>
        </nav>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.jumbotwo">
    <!-- show only on startpage -->
    <xsl:if test="//div/@class='jumbotwo'">
    </xsl:if>
  </xsl:template>

  <xsl:template name="mir.footer">
    <div class="container">
      <div class="row">
        <div class="col-12 col-sm-6 order-2 order-sm-1">
          <ul class="internal_links nav navbar-nav navbar-expand-md">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='below']/*" />
          </ul>
        </div>
        <div class="col-12 col-sm-6 ipu-logo-box order-1 order-sm-2">
          <a href="https://www.ipu-berlin.de/">
            <img class="mb-5" src="{$WebApplicationBaseURL}images/ipu-logo-web_de.svg" alt="Logo IPU" />
          </a>
        </div>
        <div class="col-12 order-3">
          <div class="copyright-box">
            Copyright ©
            <xsl:value-of select="date:year(date:date())" />
            · International Psychoanalytic University Berlin
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="project.generate_single_menu_entry">
    <xsl:param name="menuID" />
    <xsl:variable name="menu-item" select="$loaded_navigation_xml/menu[@id=$menuID]/item" />
    <li class="nav-item">
      <xsl:variable name="active-class">
        <xsl:choose>
          <xsl:when test="$menu-item/@href = $browserAddress">
            <xsl:text>active</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>not-active</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="full-url">
        <xsl:call-template name="resolve-full-url">
          <xsl:with-param name="link" select="$menu-item/@href" />
        </xsl:call-template>
      </xsl:variable>
      <a id="{$menuID}" href="{$full-url}" class="nav-link {$active-class}">
        <xsl:apply-templates select="$menu-item" mode="linkText" />
      </a>
    </li>
  </xsl:template>


  <xsl:template name="resolve-full-url">
    <xsl:param name="link" />
    <xsl:param name="base-url" select="$WebApplicationBaseURL" />
    <xsl:choose>
      <xsl:when test="
        starts-with($link,'http:')
        or starts-with($link,'https:')
        or starts-with($link,'mailto:')
        or starts-with($link,'ftp:')
      ">
        <xsl:value-of select="$link" />
      </xsl:when>
      <xsl:when test="starts-with($link,'/')">
        <xsl:choose>
          <xsl:when test="substring($base-url, string-length($base-url), 1) = '/'">
            <xsl:value-of select="concat(substring($base-url, 1, string-length($base-url) - 1), $link)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($base-url, $link)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="substring($base-url, string-length($base-url), 1) = '/'">
            <xsl:value-of select="concat($base-url, $link)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($base-url, '/', $link)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mir.powered_by">
    <xsl:variable name="version" select="concat('MyCoRe ', mcrversion:getCompleteVersion())" />
    <div id="powered_by">
      <a href="https://www.mycore.de">
        <img
          src="{$WebApplicationBaseURL}mir-layout/images/mycore_logo_small_invert.png"
          title="{$version}"
          alt="powered by MyCoRe" />
      </a>
    </div>
  </xsl:template>

</xsl:stylesheet>
