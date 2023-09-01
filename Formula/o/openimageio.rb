class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://ghproxy.com/https://github.com/OpenImageIO/oiio/archive/v2.4.14.0.tar.gz"
  sha256 "92ad4b107394b273397baa1abe90207e1f8ef9fd52ffbfc23b46e3b0005d4439"
  license "Apache-2.0"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f86914b8278ba0e57e974e04fceb57fa50c49c869e1ccd409998690fca0ca8a"
    sha256 cellar: :any,                 arm64_monterey: "3fb3d5230e3a2cc305164fa75830ac729ccc474762f7f9fa363abc3bcbf41362"
    sha256 cellar: :any,                 arm64_big_sur:  "33fba08d2969cf7ebd4fb1c4958ca04dab6bda5a8fd26f1dc6829896f949143d"
    sha256 cellar: :any,                 ventura:        "42b1130e561f4cb83bcb2cbe41d0848c0d0b0f420e8477b563042e0c3d554889"
    sha256 cellar: :any,                 monterey:       "6201823189b9bb1f9996f367f487ba5473e701dfe3044e4cd6efbb277cbd4e56"
    sha256 cellar: :any,                 big_sur:        "b66d2b396b80c64ae74e15c90fbe290a85044be583ba34d6398378afb80b4912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438fa3498037407042506bf7abf6f928e4a3d3f1e3e75cb6cc71a724c5a2c9f4"
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
  depends_on "python@3.11"
  depends_on "webp"

  # https://github.com/OpenImageIO/oiio/blob/master/INSTALL.md
  fails_with :gcc do
    version "5"
    cause "Requires GCC 6.1 or later"
  end

  def python3
    "python3.11"
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