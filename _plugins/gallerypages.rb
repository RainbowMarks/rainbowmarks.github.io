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
          @posturl = gallery[1]

          #puts "Working on : " +  @galleryname
          #puts "Working on posturl : " +  gallery[1]["posturl"].to_s
          #puts "Working on gallery : " +  gallery[1]["gallery"].to_s
          gallery[1]["gallery"].each do |image|
            #puts "Working on galleryarray : " +  galleryarray.to_s
            #galleryarray[1].each do |image|
              #puts image['image_path']
              #puts image['image-caption']
              #puts image['image-copyright']
              #puts 'Generate page' + image['image_path']
              site.pages << GalleryImagePage.new(site, "galleries/" + @galleryname, image['image_path'], image['image-caption'],image['image-copyright'], gallery[1]["posturl"].to_s, image['image-id'])
              
            #end
          
          end 
        end 
        # puts "post-folder+gallery loop"




        # site.pages << GalleryPage.new(site, category, posts)
      end
    end
    #end
  
    # Subclass of `Jekyll::Page` with custom method definitions.
    class GalleryImagePage < Jekyll::Page
      def initialize(site, urlpath, imgpath, caption, copyright, posturl, imageid)
        @site = site             # the current site instance.
        @base = site.source      # path to the source directory.
        @dir  = urlpath         # the directory the page will reside in.

        @imageid = imageid-1
  
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
          'posturl' => posturl + "?rbmphoto=" + @imageid.to_s
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