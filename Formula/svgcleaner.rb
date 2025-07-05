class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://ghfast.top/https://github.com/RazrFalcon/svgcleaner/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "dcf8dbc8939699e2e82141cb86688b6cd09da8cae5e18232ef14085c2366290c"
  license "GPL-2.0-or-later"
  head "https://github.com/RazrFalcon/svgcleaner.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"in.svg").write <<~EOS
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <svg
         xmlns="http://www.w3.org/2000/svg"
         version="1.1"
         width="150"
         height="150">
        <rect
           width="90"
           height="90"
           x="30"
           y="30"
           style="fill:#0000ff;fill-opacity:0.75;stroke:#000000"/>
      </svg>
    EOS
    system bin/"svgcleaner", "in.svg", "out.svg"
  end
end