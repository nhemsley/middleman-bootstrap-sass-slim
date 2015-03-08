require 'pathname'
require 'nokogiri'


###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

set :css_dir, 'css'

set :js_dir, 'js'

set :images_dir, 'img'

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
helpers do
  def embed_svg(file, id = false, width = false, height = false)
    svg_file = Pathname.new(source_dir).join(config.images_dir, file)
    svg_data = IO.read(svg_file.to_s)
    return svg_data unless id

    doc = Nokogiri::XML(svg_data)
    node = doc.xpath("//*[@id='title']").first
    template_file = Pathname.new(source_dir).join(config.images_dir, 'template.svg')
    template_data = IO.read(template_file)
    template_doc = Nokogiri::XML(template_data)

    container = template_doc.xpath("//*[@id='doc']").first

    # container.set_attribute('width', width) if width
    # container.set_attribute('height', height) if height

    # if width && height
      container.set_attribute('viewBox', "0 0 #{width} #{height}")
    # end
    # binding.pry
    container.add_child node
    container.to_xml.sub('<default:g', '<g')

  end

  def nav_link(link_text, url, options = {})
    # binding.pry
    options[:class] ||= ""
    # binding.pry
    active="active" if current_page.url == '/' && url == '/index.html'
    active="active" if url == current_page.url
    "<li class='#{active}'>" << link_to(link_text, url, options) << "</li>"
  end
end

# embed_svg('assets.svg') #, 'title')

# Slim configuration
Slim::Engine.set_default_options pretty: true, sort_attrs: false

# development configuration
configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  compass_config do |config|
    config.output_style = :expanded
    config.line_comments = false
  end

  # Minify on build
  Slim::Engine.set_default_options pretty: false, sort_attrs: true
  activate :minify_css
  activate :minify_javascript

  # Compress images
  # https://github.com/toy/image_optim#binaries-installation
  # activate :imageoptim

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets
  set :relative_links, true

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

# middleman-deploy configuration
activate :deploy do |deploy|
  # Automatically run `middleman build` during `middleman deploy`
  # deploy.build_before = true

  # rsync, ftp, sftp, or git
  deploy.method = :git

  # remote name or git url, default: origin
  # deploy.remote   = 'custom-remote'

  # default: gh-pages
  # deploy.branch   = 'master'

  # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.strategy = :submodule
end


###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }
