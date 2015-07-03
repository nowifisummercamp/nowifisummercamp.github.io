require 'slim'

###
# Blog settings
###
Time.zone = "Paris"
I18n.config.enforce_available_locales = false

activate :blog do |blog|
    blog.name = "blog"
    blog.permalink = "/{title}.html"
    blog.sources = "/blog/{year}-{month}-{day}-{title}.html"
    blog.layout = "layouts/blog"
    blog.default_extension = ".markdown"
    blog.new_article_template = "source/new-article.erb" 

  # Enable pagination
    blog.paginate = true
    blog.per_page = 20
    blog.page_link = "/{num}"

  # Custom categories
    blog.custom_collections = {
      category: {
        link: '/categories/{category}.html',
        template: '/category.html'
      }
    }
end

page "/feed.xml", layout: false

###
# Disqus comments
###
activate :disqus do |d|
  d.shortname = 'nowifisummercamp'
end

###
# Autoprefixer
###
activate :autoprefixer do |config|
  config.browsers = ['last 2 versions', 'Explorer >= 9']
end

###
# Google Analytics
###
activate :google_analytics do |ga|
  ga.tracking_id = data.settings.google_analytics.tracking_code
  ga.anonymize_ip = true
  ga.debug = false
  ga.development = false
  ga.minify = true
end

###
# Email protection
###
activate :protect_emails

###
# Directory indexes
###
activate :directory_indexes

page "/sitemap.xml", layout: false
page "/merci.html",  :directory_index => false
page "/404.html",    :directory_index => false

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
helpers do
  def find_author(author_slug)
    author_slug = author_slug.downcase
    result = data.members.select {|member| member.keys.first == author_slug }
    raise ArgumentError unless result.any?
    result.first
  end

  def retina_image(file_name)
    if file_name
      file_name.sub(/\.(jpg|png|gif)/, "@2x.\\1")
    end
  end

  def set_hero_image(image)
    styles = %{<style>.header{background-image: url('/images/backgrounds/small/#{image}');}
    @media screen and (min-width: 25em){.header{background-image: url('/images/backgrounds/medium/#{image}');}}
    @media screen and (min-width: 50em){.header{background-image: url('/images/backgrounds/#{image}');}}</style>}
    return styles
  end
end

set :css_dir,    'stylesheets'
set :js_dir,     'javascripts'
set :images_dir, 'images'

activate :i18n, mount_at_root: :fr

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
  deploy.build_before = true
end


# Build-specific configuration
configure :build do

  # Favicon
  activate :favicon_maker do |f|
    f.template_dir  = File.join(root, 'source')
    f.output_dir    = File.join(root, 'build')
    f.icons = {
      "_favicon_template.png" => [
        { icon: "apple-touch-icon-152x152-precomposed.png" },
        { icon: "apple-touch-icon-144x144-precomposed.png" },
        { icon: "apple-touch-icon-120x120-precomposed.png" },
        { icon: "apple-touch-icon-114x114-precomposed.png" },
        { icon: "apple-touch-icon-76x76-precomposed.png" },
        { icon: "apple-touch-icon-72x72-precomposed.png" },
        { icon: "apple-touch-icon-60x60-precomposed.png" },
        { icon: "apple-touch-icon-57x57-precomposed.png" },
        { icon: "apple-touch-icon-precomposed.png", size: "57x57" },
        { icon: "apple-touch-icon.png", size: "57x57" },
        { icon: "favicon-196x196.png" },
        { icon: "favicon-160x160.png" },
        { icon: "favicon-96x96.png" },
        { icon: "favicon-32x32.png" },
        { icon: "favicon-16x16.png" },
        { icon: "favicon.png", size: "16x16" },
        { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },
        { icon: "mstile-144x144", format: "png" },
      ]
    }
  end

  # Minification
  activate :minify_css
  activate :minify_javascript
  activate :minify_html, remove_input_attributes: false

  # Gzip compression
  activate :gzip

  # Use relative URLs
  activate :relative_assets

  # Site map
  activate :sitemap, hostname: data.settings.site.url

end