class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://ghproxy.com/https://github.com/OpenImageIO/oiio/archive/refs/tags/v2.5.5.0.tar.gz"
  sha256 "8c0de6cd8cfc8aeb696e9cf4fbd067c8c1d9fc22a3b7b81dfeda857ab526b1c8"
  license "Apache-2.0"
  revision 2
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc6a6da12c742f90f6aff0ff6845d3ee32de6f7757999017dc287387b686edf1"
    sha256 cellar: :any,                 arm64_ventura:  "8b407810bea37c8fcf647a292a658bc115b840cf7f6c9df4c675da0b0d0e5f31"
    sha256 cellar: :any,                 arm64_monterey: "31e2e7490f02ddb8c5d6ddf8685d63078d7cb96e40476c44a943de545fde57d7"
    sha256 cellar: :any,                 sonoma:         "6fa1c1c6e58afb55e5a341761afd2646bda610764c3217e226bec639faa4933d"
    sha256 cellar: :any,                 ventura:        "a5e5bd28663996e9ada692f656128b7eeb03f213020829b7951aafeb0119c0b8"
    sha256 cellar: :any,                 monterey:       "2a6f6e6f85e51d0e4aa171115332601870cdf9780c04c4406c777235c5f2ebe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31e1df2db35abca64701c4e49a2a55cb113074c6f98f5bdca94094b3f3c464ce"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "pugixml"
  depends_on "pybind11"
  depends_on "python@3.12"
  depends_on "webp"

  # https://github.com/OpenImageIO/oiio/blob/master/INSTALL.md
  fails_with :gcc do
    version "5"
    cause "Requires GCC 6.1 or later"
  end

  def python3
    "python3.12"
  end

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DPython_EXECUTABLE=#{which(python3)}
      -DPYTHON_VERSION=#{py3ver}
      -DBUILD_MISSING_FMT=OFF
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DOIIO_BUILD_TESTS=OFF
      -DUSE_DCMTK=OFF
      -DUSE_EXTERNAL_PUGIXML=ON
      -DUSE_JPEGTURBO=ON
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}/oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    assert_match version.major_minor_patch.to_s, pipe_output(python3, output, 0)
  end
end