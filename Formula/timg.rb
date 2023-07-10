class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://ghproxy.com/https://github.com/hzeller/timg/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "aa457f401b0517ba814efc62ededa3ab3f4edc1f40fb6048c58d52f01dfd9ba2"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "748b301f32c0151af23b1df47f1d247b29407ee7f48baccb929f3a3db2dcdf12"
    sha256 cellar: :any,                 arm64_monterey: "4d5269a1a2e8cff58624e44ff0ee5da457f1837eb270bc7f869dc6e6c4c94f85"
    sha256 cellar: :any,                 arm64_big_sur:  "8f0d4f6c499b251d7588f246ac81aac8dabe4e6782c5a27b529d3c67afcdfe2c"
    sha256 cellar: :any,                 ventura:        "fbeb6b0d026bf9ec26674582c9007b8467331dd08ff48336633081293ec52a60"
    sha256 cellar: :any,                 monterey:       "caa1f64bb9a7ac8c4ed48d8c4044753bbf46a9e4d96607db89a2e289d58465bf"
    sha256 cellar: :any,                 big_sur:        "ba4556e38097ea8189bf5515874c6ffaa8a0636eb0c78a6a1bffac928ccff322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "477db23edbbf5e02a1a1f297eb4247e2a1997fd7595587a20a950160d1bc607c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libdeflate"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libsixel"
  depends_on "openslide"
  depends_on "webp"

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/timg", "--version"
    system "#{bin}/timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}/timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}/timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end