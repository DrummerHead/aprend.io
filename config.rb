###
# Page options, layouts, aliases and proxies
###

page "/index.html", :layout => :landing

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
      page_id: subject_data.metadata.page_id,
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
        page_id: page_data.metadata.page_id,
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

# Reload the browser automatically whenever files change
activate :livereload do |livereload|
  livereload.host = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :haml, { :attr_wrapper => "\"", :format => :html5 }




# Build-specific configuration
configure :build do
  activate :minify_html
  activate :minify_css
  activate :minify_javascript
end
