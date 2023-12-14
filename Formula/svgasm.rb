class Svgasm < Formula
  desc "SVG animation from multiple SVGs or single GIF using tracer"
  homepage "https://github.com/tomkwok/svgasm/"
  license "Apache-2.0"
  head "https://github.com/tomkwok/svgasm.git"

  depends_on "nicerloop/nicerloop/svgcleaner"
  depends_on "graphicsmagick"
  depends_on "potrace"

  def install
    system "make"
    bin.install "svgasm"
  end

  test do
    system "#{bin}/svgasm", "-h"
  end
end