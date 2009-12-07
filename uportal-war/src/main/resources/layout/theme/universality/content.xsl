<?xml version="1.0" encoding="utf-8"?>
<!--

    Copyright (c) 2000-2009, Jasig, Inc.
    See license distributed with this file and available online at
    https://www.ja-sig.org/svn/jasig-parent/tags/rel-10/license-header.txt

-->
<!--
 | This file determines the presentation of portlet (and channel) containers.
 | Portlet content is rendered outside of the theme, handled entirely by the portlet itself.
 | The file is imported by the base stylesheet universality.xsl.
 | Parameters and templates from other XSL files may be referenced; refer to universality.xsl for the list of parameters and imported XSL files.
 | For more information on XSL, refer to [http://www.w3.org/Style/XSL/].
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dlm="http://www.uportal.org/layout/dlm"
    xmlns:upGroup="xalan://org.jasig.portal.security.xslt.XalanGroupMembershipHelper"
    exclude-result-prefixes="upGroup">  
  
  <!-- ========== TEMPLATE: PORTLET ========== -->
  <!-- ======================================= -->
  <!--
   | This template renders the portlet containers: chrome and controls.
  -->
  <xsl:template match="channel">
    <!-- This variable appears to be obsolete.
    <xsl:variable name="portletClassName">
      portlet-container <xsl:value-of select="@fname"/> 
    </xsl:variable>-->
    
    <xsl:variable name="PORTLET_LOCKED"> <!-- Test to determine if the portlet is locked in the layout. -->
      <xsl:choose> 
        <xsl:when test="@dlm:moveAllowed='false'">locked</xsl:when> 
        <xsl:otherwise>moveable</xsl:otherwise> 
      </xsl:choose> 
    </xsl:variable>
    
    <xsl:variable name="PORTLET_CHROME"> <!-- Test to determine if the portlet has been given the highlight flag. -->
      <xsl:choose>
        <xsl:when test="./parameter[@name='showChrome']/@value='false'">no-chrome</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="PORTLET_HIGHLIGHT"> <!-- Test to determine if the portlet has been given the highlight flag. -->
      <xsl:choose>
        <xsl:when test="./parameter[@name='highlight']/@value='true'">highlight</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="PORTLET_ALTERNATE"> <!-- Test to determine if the portlet has been given the alternate flag. -->
      <xsl:choose>
        <xsl:when test="./parameter[@name='alternate']/@value='true'">alternate</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- Tests for optional portlet parameter removeFromLayout which can be used to not render a portlet in the layout.  The main use case for this function is to have a portlet be a quicklink and then remove it from otherwise rendering. -->
    <xsl:if test="not(./parameter[@name='removeFromLayout']/@value='true') and not(./parameter[@name='PORTLET.removeFromLayout']/@value='true')">
    
    <!-- ****** PORTLET CONTAINER ****** -->
    <div id="portlet_{@ID}" class="portlet-container {@fname} {$PORTLET_LOCKED} {$PORTLET_CHROME} {$PORTLET_ALTERNATE} {$PORTLET_HIGHLIGHT}"> <!-- Main portlet container.  The unique ID is needed for drag and drop.  The portlet fname is also written into the class attribute to allow for unique rendering of the portlet presentation. -->
          
        <!-- PORTLET CHROME CHOICE -->
        <xsl:choose>
          <!-- ***** REMOVE CHROME ***** -->
          <xsl:when test="parameter[@name = 'showChrome']/@value = 'false'">
              <!-- ****** START: PORTLET CONTENT ****** -->
              <div id="portletContent_{@ID}" class="portlet-content"> <!-- Portlet content container. -->
                <div class="portlet-content-inner">  <!-- Inner div for additional presentation/formatting options. -->
                  <xsl:copy-of select="."/> <!-- Write in the contents of the portlet. -->
                </div>
              </div>
          </xsl:when>
        
          <!-- ***** RENDER CHROME ***** -->
          <xsl:otherwise>
            <div class="portlet-container-inner">
            <!-- ****** PORTLET TOP BLOCK ****** -->
            <xsl:call-template name="portlet.top.block"/> <!-- Calls a template of institution custom content from universality.xsl. -->
            <!-- ****** PORTLET TOP BLOCK ****** -->
            
            <!-- ****** PORTLET TITLE AND TOOLBAR ****** -->
            <div id="toolbar_{@ID}" class="portlet-toolbar"> <!-- Portlet toolbar. -->
              <h2> <!-- Portlet title. -->
                <a name="{@ID}" id="{@ID}" href="{$BASE_ACTION_URL}?uP_root={@ID}"> <!-- Reference anchor for page focus on refresh and link to focused view of channel. -->
                  UP:CHANNEL_TITLE-{<xsl:value-of select="@ID" />}
                </a>
              </h2>
              <xsl:if test="//layout"> <!-- As long as the portlet is not detached, render the portlet controls. -->
                <xsl:call-template name="controls"/>
              </xsl:if>
            </div>
            
            <!-- ****** PORTLET CONTENT ****** -->
            <div id="portletContent_{@ID}" class="portlet-content fl-fix"> <!-- Portlet content container. -->
              <div class="portlet-content-inner">  <!-- Inner div for additional presentation/formatting options. -->
                <xsl:copy-of select="."/> <!-- Write in the contents of the portlet. -->
              </div>
            </div>
            
            <!-- ****** PORTLET BOTTOM BLOCK ****** -->
            <xsl:call-template name="portlet.bottom.block"/> <!-- Calls a template of institution custom content from universality.xsl. -->
            <!-- ****** PORTLET BOTTOM BLOCK ****** -->
            </div>
          </xsl:otherwise>
        </xsl:choose>

    </div>
    
    </xsl:if>
  
  </xsl:template>
  <!-- ======================================= -->
  
  
  <!-- ========== TEMPLATE: PORLET FOCUSED ========== -->
  <!-- ============================================== -->
  <!--
   | These two templates render the focused portlet content.
  -->
  <xsl:template match="focused">
  	<div class="portal-page-column single">
    	<div class="portal-page-column-inner"> <!-- Column inner div for additional presentation/formatting options.  -->
  			<xsl:apply-templates select="channel" mode="focused"/>
      </div>
    </div>
  </xsl:template>
  
  <xsl:template match="channel" mode="focused">
    <div id="portlet_{@ID}" class="portlet-container">  <!-- Portlet container. -->
      <div id="toolbar_{@ID}" class="portlet-toolbar">  <!-- Render the portlet toolbar. -->
      	<xsl:call-template name="controls"/> <!-- Call the portlet controls into the toolbar. -->
      </div>
      <div id="portletContent_{@ID}" class="portlet-content fl-fix">
      	<div class="portlet-content-inner">
      		<xsl:copy-of select="."/> <!-- Write in the contents of the portlet. -->
    		</div>
    	</div>
    </div>
  </xsl:template>
  <!-- ============================================== -->
  
  <!-- ========== TEMPLATE: PORTLET CONTROLS ========== -->
  <!-- This template renders portlet controls.  Each control has a unique class for assigning icons or other specific presentation. -->
  <xsl:template name="controls">
    <div class="portlet-controls">
      <xsl:if test="not(@hasHelp='false')"> <!-- Help. -->
      	<a href="{$BASE_ACTION_URL}?uP_help_target={@ID}#{@ID}" title="{$TOKEN[@name='PORTLET_HELP_LONG_LABEL']}" class="portlet-control help">
      	  <span><xsl:value-of select="$TOKEN[@name='PORTLET_HELP_LABEL']"/></span>
        </a>
      </xsl:if>
      <xsl:if test="not(@hasAbout='false')"> <!-- About. -->
      	<a href="{$BASE_ACTION_URL}?uP_about_target={@ID}#{@ID}" title="{$TOKEN[@name='PORTLET_ABOUT_LONG_LABEL']}" class="portlet-control about">
      	  <span><xsl:value-of select="$TOKEN[@name='PORTLET_ABOUT_LABEL']"/></span>
        </a>
      </xsl:if>
      <xsl:if test="not(@editable='false')"> <!-- Edit. -->
      	<a href="{$BASE_ACTION_URL}?uP_edit_target={@ID}#{@ID}" title="{$TOKEN[@name='PORTLET_EDIT_LONG_LABEL']}" class="portlet-control edit">
      	  <span><xsl:value-of select="$TOKEN[@name='PORTLET_EDIT_LABEL']"/></span>
        </a>
      </xsl:if>
      <xsl:if test="@printable='true'"> <!-- Print. -->
      	<a href="{$BASE_ACTION_URL}?uP_print_target={@ID}#{@ID}" title="{$TOKEN[@name='PORTLET_PRINT_LONG_LABEL']}" class="portlet-control print">
      	  <span><xsl:value-of select="$TOKEN[@name='PORTLET_PRINT_LABEL']"/></span>
        </a>
      </xsl:if>
      <xsl:if test="not(//focused)"> <!-- Focus. -->
      	<a href="{$BASE_ACTION_URL}?uP_root={@ID}" title="{$TOKEN[@name='PORTLET_MAXIMIZE_LONG_LABEL']}" class="portlet-control focus">
      	  <span><xsl:value-of select="$TOKEN[@name='PORTLET_MAXIMIZE_LABEL']"/></span>
        </a>
      </xsl:if>
      <xsl:if test="not(@dlm:deleteAllowed='false') and not(//focused) and /layout/navigation/tab[@activeTab='true']/@immutable='false'">
      	<a id="removePortlet_{@ID}" title="{$TOKEN[@name='PORTLET_REMOVE_LONG_LABEL']}" href="{$BASE_ACTION_URL}?uP_remove_target={@ID}" class="portlet-control remove">
      	  <span><xsl:value-of select="$TOKEN[@name='PORTLET_REMOVE_LABEL']"/></span>
        </a>
      </xsl:if>
      <xsl:if test="//focused[@in-user-layout='no'] and upGroup:isChannelDeepMemberOf(//focused/channel/@fname, 'local.1')"> <!-- Add to layout. -->
        <a id="focusedContentDialogLink" href="javascript:;" title="{$TOKEN[@name='PORTLET_ADD_LONG_LABEL']}" class="portlet-control add">
          <span><xsl:value-of select="$TOKEN[@name='PORTLET_ADD_LABEL']"/></span>
        </a>
      </xsl:if>
    </div>
  </xsl:template>
  <!-- ========== TEMPLATE: PORTLET CONTROLS ========== -->
		
</xsl:stylesheet>