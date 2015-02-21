require 'helper'

class Jekyll::AutoImageTest < Minitest::Test
  def set_page_image (page, image_path) 
    page.instance_variable_set(:@content, '<img attribute="blabla" src="' + image_path + '">')
  end
  
  context 'AutoImage' do
    
    setup do
      
      @default_image_path = '/assets/default_image.png'
          
      # Sites   
      @site = Jekyll::Site.new(Jekyll::Configuration::DEFAULTS)
      
      @config = Jekyll::Configuration::DEFAULTS.clone
      @config['image'] = @default_image_path
      @site_with_default_image = Jekyll::Site.new(@config)
      
      # Pages
      @no_image_page = Jekyll::Page.new(@site, File.expand_path('../fixtures/', __FILE__), '', 'no-image.md')
      @front_matter_image_page = Jekyll::Page.new(@site, File.expand_path('../fixtures/', __FILE__), '', 'front-matter-image.md')
      @contents_image_page = Jekyll::Page.new(@site, File.expand_path('../fixtures/', __FILE__), '', 'contents-image.md')
      @contents_html_page = Jekyll::Page.new(@site, File.expand_path('../fixtures/', __FILE__), '', 'contents-html.html')
      
      @auto_image = Jekyll::AutoImageGenerator.new
      @auto_image.generate(@site)
      @auto_image_with_default_image = Jekyll::AutoImageGenerator.new
      @auto_image_with_default_image.generate(@site_with_default_image)
      
      #@page.instance_variable_set(:@content, '<div>ivan.tse1@gmail.com</div>')
      #@site.pages << @page
      #@email_link = '<div><a href="mailto:ivan.tse1@gmail.com">ivan.tse1@gmail.com</a></div>'
    end
    
        
    #
    # FALLBACK LOGIC TESTS
    #
    
    # Tests without {{site.image}}
    
    should 'not be defined site image by default' do
      assert_nil @site.config['image'] 
    end
    
    should 'not return image when not set in config and not included in page' do
      assert_nil @auto_image.get_image(@no_image_page)
    end
    
     should 'use front matter image whenever defined' do
      assert_equal @front_matter_image_page.data['image'], @auto_image.get_image(@front_matter_image_page)
    end
    
    should 'detect contents image on markdown' do
      assert_equal '/assets/contents-image.png', @auto_image.get_image(@contents_image_page)
    end
      
    should 'detect contents image in html' do
      assert_equal '/assets/contents-html.png',  @auto_image.get_image(@contents_html_page)
    end
  
    # Tests with {{site.image}} defined
    
    should 'be defined site_image in config' do
      assert_equal @default_image_path, @site_with_default_image.config['image'] 
    end  
    
    should 'return default image when page does not have image' do
      assert_equal @site_with_default_image.config['image'], @auto_image_with_default_image.get_image(@no_image_page)
    end  
    
    should 'return front matter image even if default image is defined' do
      assert_equal  @front_matter_image_page.data['image'], @auto_image_with_default_image.get_image(@front_matter_image_page)
    end  
    
    
    #
    # Tests to check if the regexp works in some use cases
    #
    should 'find contents image that includes http' do
      image ="http://github.com/merlos/jekyll-auto-image/yes.png"
      set_page_image(@no_image_page,image)
      assert image, @auto_image.get_image(@no_image_page)
    end
    
    #
    # Tests to check if the regexp works in some use cases
    #
    should 'find image with weird characters in name' do
      image ="http://github.com/merlos/%$·$%&/(),.-,.-./yes.png"
      set_page_image(@no_image_page,image)
      assert image, @auto_image.get_image(@no_image_page)
    end
    
    #
    # Tests to check if the regexp works in some use cases
    #
    should 'not find image with space in name' do
      image ="http://github.com/merlos/jekyll auto image/yes.png"
      set_page_image(@no_image_page,image)
      assert_nil @auto_image.get_image(@no_image_page)
    end
    
    
  end
end