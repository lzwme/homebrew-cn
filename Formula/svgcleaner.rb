class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https:github.comRazrFalconsvgcleaner"
  url "https:github.comRazrFalconsvgcleanerarchiverefstagsv0.9.5.tar.gz"
  sha256 "dcf8dbc8939699e2e82141cb86688b6cd09da8cae5e18232ef14085c2366290c"
  license "GPL-2.0"
  head "https:github.comRazrFalconsvgcleaner.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"in.svg").write <<~EOS
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <svg
         xmlns="http:www.w3.org2000svg"
         version="1.1"
         width="150"
         height="150">
        <rect
           width="90"
           height="90"
           x="30"
           y="30"
           style="fill:#0000ff;fill-opacity:0.75;stroke:#000000">
      <svg>
    EOS
    system bin"svgcleaner", "in.svg", "out.svg"
  end
end