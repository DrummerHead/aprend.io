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



pages_for_pagination = []
pages_for_pagination_index = 0


data.pages.each do |subject, subject_data|
  if !subject_data.children
    pages_for_pagination << "/#{subject_data.metadata.url}"
  else
    subject_data.children.each do |page, page_data|
      pages_for_pagination << "/#{subject_data.metadata.url}/#{page_data.metadata.url}"
    end
  end
end

data.pages.each do |subject, subject_data|
  if !subject_data.children
    proxy "/#{subject_data.metadata.url}/index.html", "/templates/page.html", locals: {
      subject_title: subject_data.metadata.page_title,
      page_title: nil,
      number: subject_data.metadata.number,
      video_url: subject_data.video_url,
      description: subject_data.description,
      code_url: subject_data.code_url,
      links: subject_data.links,
      keywords: subject_data.keywords,
      previous_page: pages_for_pagination_index > 0 ? pages_for_pagination[pages_for_pagination_index-1] || nil : nil,
      next_page: pages_for_pagination[pages_for_pagination_index+1] || nil
    }, ignore: true

    pages_for_pagination_index += 1
  else
    proxy "/#{subject_data.metadata.url}/index.html", "/templates/subject.html", locals: {
      subject_title: subject_data.metadata.page_title,
      subject_url: subject_data.metadata.url,
      pages: subject_data.children
    }, ignore: true

    subject_data.children.each do |page, page_data|
      proxy "/#{subject_data.metadata.url}/#{page_data.metadata.url}/index.html", "/templates/page.html", locals: {
        subject_title: subject_data.metadata.page_title,
        page_title: page_data.metadata.page_title,
        number: page_data.metadata.number,
        video_url: page_data.video_url,
        description: page_data.description,
        code_url: page_data.code_url,
        links: page_data.links,
        keywords: page_data.keywords,
        previous_page: pages_for_pagination_index > 0 ? pages_for_pagination[pages_for_pagination_index-1] || nil : nil,
        next_page: pages_for_pagination[pages_for_pagination_index+1] || nil
      }, ignore: true

      pages_for_pagination_index += 1
    end
  end
end














###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :haml, { :attr_wrapper => "\"", :format => :html5 }

# Build-specific configuration
configure :build do
  activate :minify_html
  activate :minify_css
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
