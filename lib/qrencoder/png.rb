require 'chunky_png'

module QREncoder
  class PNG
    attr_reader :canvas,
      :background,
      :margin,
      :pixels_per_module,
      :points,
      :width

    ##
    # Takes an optional hash of options. See QRCode#png for details.
    def initialize(qrcode, options={})
      @points = qrcode.points
      @margin = options[:margin] || 4
      @pixels_per_module= options[:pixels_per_module] || 1
      @background = options[:transparent] ? ChunkyPNG::Color::TRANSPARENT : ChunkyPNG::Color::WHITE
      @width = (qrcode.width + (2 * margin)) * pixels_per_module

      @canvas = ChunkyPNG::Image.new(width, width, background)
      plot_points
    end

    def method_missing(method, *args, &block)
      if canvas.respond_to?(method)
        canvas.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to?(method)
      super || canvas.respond_to?(method)
    end

    private
    def plot_points
      points.each do |point|
        pixels_per_module.times do |x_offset|
          x = (point[0] + margin) * pixels_per_module + x_offset
          pixels_per_module.times do |y_offset|
            y = (point[1] + margin) * pixels_per_module + y_offset
            canvas[x,y] = ChunkyPNG::Color::BLACK
          end
        end
      end
    end

  end
end
