module GalleryPages
    class GalleryPageGenerator < Jekyll::Generator
      safe true
  
      # for each post, look for a gallery, then loop each image
      # post / gallery / image number .thml
      
      def generate(site)
        #site.posts.each do |post|
          #@galleryname = post["galleryname"]
         
          #  - image_path: /img/posts/UnboundGravel/WestOfAmericus/WestOfAmericus-1.jpg
          #  image-caption: 2021 Unbound Gravel West of Americus
          #  image-copyright: © RainbowMarks.com

          #loop through folder and specific (gallery1) yaml file
          #puts "pre-folder+gallery loop"
          #site.data["gallery"]["gallery1"].each do |g|
          #  g[1].each do |image|
          #    puts image['image_path']
          #  end
          #end 
          #puts "post-folder+gallery loop"


        #loop through folder and each yaml file
        #puts "pre-folder+gallery loop"
        site.data["gallery"].each do |gallery|
          @galleryname = gallery[0]

          puts "Working on : " +  @galleryname
          gallery[1].each do |galleryarray|
            
            galleryarray[1].each do |image|
              #puts image['image_path']
              #puts image['image-caption']
              #puts image['image-copyright']
              #puts 'Generate page' + image['image_path']
              site.pages << GalleryImagePage.new(site, "galleries/" + @galleryname, image['image_path'], image['image-caption'],image['image-copyright'])
              
            end
          
          end 
        end 
        # puts "post-folder+gallery loop"




        # site.pages << GalleryPage.new(site, category, posts)
      end
    end
    #end
  
    # Subclass of `Jekyll::Page` with custom method definitions.
    class GalleryImagePage < Jekyll::Page
      def initialize(site, urlpath, imgpath, caption, copyright)
        @site = site             # the current site instance.
        @base = site.source      # path to the source directory.
        @dir  = urlpath         # the directory the page will reside in.
  
        arrUrl = imgpath.split('.')
        @basename = arrUrl[arrUrl.length-2].split("/").last
        # All pages have the same filename, so define attributes straight away.
        
        @ext      = '.html'      # the extension.
        
        # puts 'Basename + ext: ' + @basename + @ext
        # Initialize data hash with a key pointing to all posts under current category.
        # This allows accessing the list in a template via `page.linked_docs`.
        @data = {
          'image_path' => imgpath,
          'image-caption' => caption,
          'image-copyright' => copyright, 
          'header-img' => imgpath, 
          'permalink' => @dir + '/' + @basename + @ext
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
          :category   => @dir,
          :basename   => @basename + @ext,
          :output_ext => @ext,
        }
      end
    end
  end