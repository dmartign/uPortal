/**
 * Licensed to Jasig under one or more contributor license
 * agreements. See the NOTICE file distributed with this work
 * for additional information regarding copyright ownership.
 * Jasig licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a
 * copy of the License at:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.jasig.portal.portlet.rendering;

import java.io.PrintWriter;
import java.io.Writer;

import javax.portlet.Event;
import javax.portlet.PortletMode;
import javax.portlet.WindowState;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jasig.portal.portlet.om.IPortletEntity;
import org.jasig.portal.portlet.om.IPortletWindowId;

/**
 * Provides easy API for executing methods on portlets. Takes care of all of the uPortal specific setup and tear down around portlet calls.
 * 
 * @author Eric Dalquist
 * @version $Revision$
 */
public interface IPortletRenderer {
    public static final WindowState EXCLUSIVE = new WindowState("EXCLUSIVE");
	public static final WindowState DETACHED = new WindowState("DETACHED");
	public static final PortletMode ABOUT = new PortletMode("ABOUT");
	public static final PortletMode CONFIG = new PortletMode("CONFIG");
	
	/**
	 * Name of the {@link javax.servlet.http.HttpServletRequest} attribute that the adaptor
	 * will store a Map of user info attributes that has support for multi-valued attributes.
	 */
	public static final String MULTIVALUED_USERINFO_MAP_ATTRIBUTE = "org.jasig.portlet.USER_INFO_MULTIVALUED";
	
	/**
	 * {@link javax.servlet.http.HttpServletRequest} attributes specific to the
	 * {@link IPortletRenderer} must be prefixed with this value to be sure they
	 * are protected from manipulation by the portlet.
	 */
	public static final String RENDERER_ATTRIBUTE_PREFIX = IPortletRenderer.class.getName();
	
	/**
	 * Attribute that the dynamic portlet title is stored using if set.
	 */
	public static final String ATTRIBUTE__PORTLET_TITLE = RENDERER_ATTRIBUTE_PREFIX + ".PORTLET_TITLE";
	
	/**
	 * Attribute that the renderer stores a {@link PrintWriter} that should be used when the portlet writes out content.
	 */
	public static final String ATTRIBUTE__PORTLET_PRINT_WRITER = RENDERER_ATTRIBUTE_PREFIX + ".PORTLET_PRINT_WRITER";
	
    /**
     * Name of the {@link org.jasig.portal.ChannelDefinition} parameter used to determine
     * if the portlet application ID should be set to the context path of the portal.
     */
    public static final String CHANNEL_PARAM__IS_FRAMEWORK_PORTLET = "isFrameworkPortlet";

    /**
     * Name of the {@link org.jasig.portal.ChannelDefinition} parameter the name of the
     * {@link org.apache.pluto.descriptors.portlet.PortletAppDD} is defined in.
     * 
     * @see org.apache.pluto.spi.optional.PortletRegistryService#getPortletApplicationDescriptor(String)
     */
    public static final String CHANNEL_PARAM__PORTLET_APPLICATION_ID = "portletApplicationId";

    /**
     * Name of the {@link org.jasig.portal.ChannelDefinition} parameter the name of the
     * {@link org.apache.pluto.descriptors.portlet.PortletDD} is defined in.
     * 
     * @see org.apache.pluto.descriptors.portlet.PortletAppDD#getPortlets()
     */
    public static final String CHANNEL_PARAM__PORTLET_NAME = "portletName";

	/**
     * Initializes the portlet within the portlet container
     * 
     * @param portletEntity The portlet entity to base the window on
     * @param portletWindowId Window ID of the portlet to inititalize, may be null
     * @param httpServletRequest The portal's request
     * @param httpServletResponse The portal's response (nothing will be written to the response)
     * @return The correct portlet window ID, this ID should be used to track the portlet that was initialized
     */
    public IPortletWindowId doInit(final IPortletEntity portletEntity, final IPortletWindowId portletWindowId, final HttpServletRequest httpServletRequest, final HttpServletResponse httpServletResponse);
    
    /**
     * Executes an action in a portlet, handles all the request and response setup and teardown
     * 
     * @param portletWindowId Portlet to target with the action
     * @param httpServletRequest The portal's request
     * @param httpServletResponse The portal's response (nothing will be written to the response)
     */
    public long doAction(IPortletWindowId portletWindowId, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse);
    
    /**
     * Executes an event in a portlet, handles all the request and response setup and teardown
     * 
     * @param portletWindowId Portlet to target with the action
     * @param httpServletRequest The portal's request
     * @param httpServletResponse The portal's response (nothing will be written to the response)
     */
    public long doEvent(IPortletWindowId portletWindowId, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Event event);
    
    /**
     * Executes a render in a portlet, handles all the request and response setup and teardown
     * 
     * @param portletWindowId Portlet to target with the render
     * @param httpServletRequest The portal's request
     * @param httpServletResponse The portal's response (nothing will be written to the response)
     * @param writer The writer to write the portlet's output to
     */
    public PortletRenderResult doRender(IPortletWindowId portletWindowId, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Writer writer);
    
    /**
     * Executes a portlet resource request.
     * 
     * @param portletWindowId
     * @param httpServletRequest
     * @param httpServletResponse
     * @param writer
     * @return
     */
    public long doServeResource(IPortletWindowId portletWindowId, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse);
    /**
     * Resets a portlet's window data to the defaults and clears all portlet scoped session data
     * 
     * @param portletWindowId Portlet to target with the render
     * @param httpServletRequest The portal's request
     * @param httpServletResponse The portal's response (nothing will be written to the response)
     */
    public void doReset(IPortletWindowId portletWindowId, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse);
}
