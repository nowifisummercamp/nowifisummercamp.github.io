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
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

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

  def set_hero_image(image)
    styles = %{<style>.header{background-image: url('/images/backgrounds/small/#{image}');}
    @media screen and (min-width: 25em){.header{background-image: url('/images/backgrounds/medium/#{image}');}}
    @media screen and (min-width: 50em){.header{background-image: url('/images/backgrounds/#{image}');}}</style>}
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
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end