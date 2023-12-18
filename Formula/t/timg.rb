class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https:timg.sh"
  url "https:github.comhzellertimgarchiverefstagsv1.5.3.tar.gz"
  sha256 "ddf2fb1fb2376d31957415d278bc34ff0ef574eb69ef96ddcb564c392d2e4c27"
  license "GPL-2.0-only"
  head "https:github.comhzellertimg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3df2e6fa948f85f2db7e3d2531db11624dc0cdb603c1905b746710c4aa25e9a2"
    sha256 cellar: :any,                 arm64_ventura:  "c6cd77aa6e606437e614f4a1aac3fef184b11e422ac14ed5798cade311380651"
    sha256 cellar: :any,                 arm64_monterey: "a033cef39938d2c48be40a8ca08a05456368e5def3a2e3380a4234959b43691e"
    sha256 cellar: :any,                 sonoma:         "59068f2f41854bb80bed0dbf2f77a87da6ec2e9db163cfcec09051fbbbdf8107"
    sha256 cellar: :any,                 ventura:        "600a3b12edddc659423dd29bf0155e85a67b0c5223aa5365b2a2fa8a69f6cf59"
    sha256 cellar: :any,                 monterey:       "d8ba48ccbcf0c0185694ffba3a8c0a881276c37e7ca93d37ad1b0fe013403d6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "badd59908809d80015f930cae24dfb61198a1f91211413dd5207344b1fbfb637"
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
    system "#{bin}timg", "--version"
    system "#{bin}timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}timg", "-pq", "-g10x10", "-o", testpath"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath"test-output.txt").read
  end
end