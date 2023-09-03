module GalleryPages
  class GalleryPageGenerator < Jekyll::Generator
    safe true

    # for each post, look for a gallery, then loop each image
    # post / gallery / image number .thml
    
    def generate(site)
      site.posts.docs.each do |post|
        @permalink = post.permalink

        #check if post contains gallery 
        if !post["gallery"].nil?
          post["gallery"].each do |gallery|
            
            @imagecount = 0
            @galleryname = gallery[0].to_s
            
            gallery[1].each do |image|
                site.pages << GalleryImagePage.new(site, "galleries/" + @galleryname, image['image_path'], image['image-caption'],image['image-copyright'], @permalink, @imagecount, @galleryname)
                @imagecount = @imagecount +1 
            end 
          end 
        end  
      end 
    end
  end
  #end

  # Subclass of `Jekyll::Page` with custom method definitions.
  class GalleryImagePage < Jekyll::Page
    def initialize(site, urlpath, imgpath, caption, copyright, posturl, imageid, galleryname)
      @site = site             # the current site instance.
      @base = site.source      # path to the source directory.
      @dir  = urlpath         # the directory the page will reside in.

      @imageid = imageid

      arrUrl = imgpath.split('.')
      
      @basename = arrUrl[arrUrl.length-2].split("/").last
      # All pages have the same filename, so define attributes straight away.
      
      @ext      = '.html'      # the extension.
      #puts 'Dir: ' + @dir
      #puts 'Basename + ext: ' + @basename + @ext
      # Initialize data hash with a key pointing to all posts under current category.
      # This allows accessing the list in a template via `page.linked_docs`.
      @data = {
        'image_path' => imgpath,
        'image-caption' => caption,
        'image-copyright' => copyright, 
        'header-img' => imgpath, 
        'posturl' => "/" + posturl + "?rbmphoto=" + @imageid.to_s + "&galleryname=" + galleryname.to_s,
        'title' => caption,
        'description' => caption,

      }

      # Look up front matter defaults scoped to type `categories`, if given key
      # doesn't exist in the `data` hash.
      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, :galleryimage, key)
      end
    end

    # Placeholders that are used in constructing page URL.
    def url_placeholders
      {
        :path   => @dir,
        :basename   => @basename,
        :output_ext => @ext,
        
      }
    end
  end
end