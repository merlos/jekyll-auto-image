module Jekyll
 
  #
  # Auto Image Generator
  # 
  # Sets {{page.image}} variable in liquid with the following fallback:
  #  
  #  1) image value in front matter
  #  2) first image in the post/pàge
  #  3) _config.yaml image default
  #  4) nothing (not set)
  #
  #  
  class PageImageGenerator < Generator
 
    def generate(site)
      @site = site
      site.pages.each do |page|
        img = get_image(page)
        page.data['image'] = img if img
      end
        # Now do the same with posts
      site.posts.each do |post|
        img = get_image(post)
        post.data['image'] = img if img
      end
    end # generate
    
    #
    # page: is either a Jekyll::Page or a Jekyll::post
    # returns the path of the first image found in the contents
    # of the page/post 
    #
    def get_image(page)
      
      # debug lines
      
      #puts page.title
      #puts page.name
      #puts page.ext
      #puts site.converters.select { |c| c.matches(page.ext) }.sort
      
      if page.data['image']
        return page.data['image']
      end
      # convert the contents to html, and extract the first <img src="" apearance
      # I know, it's not efficient, but rather easy to implement :)
      htmled = page.transform
      img_url = htmled.match(/<img.*\ssrc=[\"\']([\:\/\w\/\.]+)[\"\']/i)
      return img_url[1] if img_url != nil 
      return @site.config['image'] if @site.config['image'] != nil
      return false
    end
    
  end # class
end # module