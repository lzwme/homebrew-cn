class Diagram < Formula
  desc "CLI app to convert ASCII arts into hand drawn diagrams"
  homepage "https:github.comesimovdiagram"
  url "https:github.comesimovdiagramarchiverefstagsv1.0.6.tar.gz"
  sha256 "008594494e004c786ea65425abf10ba4ffef2e417102de83ece3ebdee5029c66"
  license "MIT"
  head "https:github.comesimovdiagram.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "049ae370aab2ab7876282b307a01bda38e2e254807f422cece826e4ec556d09e"
    sha256 arm64_sonoma:  "38ac3fbc992a5611bf30e1848123efda5274a7d994049a24ec55102871886776"
    sha256 arm64_ventura: "a234cd90fd88eaa7025cd28843b37d9feb6f07a012ee57f5e1a5a7f288677562"
    sha256 sonoma:        "3eb79fb18800c3f1c9eebc261c15f06db339d0b2df017184757b6e39126df8f8"
    sha256 ventura:       "6c8079e485d9bb3c95cb22221a6a2fdc4fe4801d6f1d965c0ac7941aecf04c79"
    sha256 x86_64_linux:  "6ba263cef3accdf1a171e19d5aebf1493c304f601dd490753ae06a0b5932c459"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "vulkan-headers" => :build
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.defaultFontFile=#{pkgshare}gloriahallelujah.ttf")

    pkgshare.install ["sample.txt", "fontgloriahallelujah.ttf"]
  end

  test do
    cp pkgshare"sample.txt", testpath
    pid = spawn bin"diagram", "-in", "sample.txt", "-out", testpath"output.png"
    sleep 1
    assert_path_exists testpath"output.png"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end