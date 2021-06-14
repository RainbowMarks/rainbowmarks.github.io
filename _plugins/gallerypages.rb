module GalleryPages
    class GalleryPageGenerator < Jekyll::Generator
      safe true
  
      # for each post, look for a gallery, then loop each image
      # post / gallery / image number .thml
      
      def generate(site)
        site.posts.each do |post|
         
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
          puts "pre-folder+gallery loop"
          site.data["gallery"].each do |g|
            # puts g[1]
            g[1].each do |g3|
              g3[1].each do |image|
                puts image['image_path']
                puts image['image-caption']
                puts image['image-copyright']
              end
            end
          end 
          puts "post-folder+gallery loop"




          # site.pages << GalleryPage.new(site, category, posts)
        end
      end
    end
  
    # Subclass of `Jekyll::Page` with custom method definitions.
   
  end