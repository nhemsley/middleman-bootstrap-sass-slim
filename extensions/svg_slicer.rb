# Grabs an SVG file, optionally pulling out a particlar node by id,
# and rendering within a template svg
class SvgSlicer

  def initialize (template)
    @template = template
  end

  # return the svg in the file
  # if an id is passed in, pull that out & load it into the template
  def slice(svg_file, id = false, width = false, height = false)
    svg_data = IO.read(svg_file.to_s)
    return svg_data unless id

    doc = Nokogiri::XML(svg_data)

    node = doc.css("\##{id}").first

    template_doc = Nokogiri::XML(@template)

    container = template_doc.css("svg").first

    # if width && height
      container.set_attribute('viewBox', "0 0 #{width} #{height}")
    # end
    # binding.pry
    container.add_child node
    container.to_xml.sub('<default:g', '<g')
  end
end

module Rack
  class SvgServer
    def initialize(options)

    end

    def call(env)
      [200, {"Content-Type" => "text/html"}, "Hello Rack!"]
    end
  end
end
