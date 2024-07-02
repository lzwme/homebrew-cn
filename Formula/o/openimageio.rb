class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https:openimageio.readthedocs.ioenstable"
  url "https:github.comAcademySoftwareFoundationOpenImageIOarchiverefstagsv2.5.13.0.tar.gz"
  sha256 "663d712e4623e5e083b4ad5c5046c7b8ba65dc73a5380e7cfc12f9950c90d217"
  license "Apache-2.0"
  head "https:github.comAcademySoftwareFoundationOpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex((?:Release[._-])?v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd4d2c035bb38e1c9e3f5100c51aa60f924c54cc2c0ba418dd65df6cad71543d"
    sha256 cellar: :any,                 arm64_ventura:  "73d83fbbcc4fde24f5d30eef7e76238f514a43cddc51b7368b927aa5aac50daf"
    sha256 cellar: :any,                 arm64_monterey: "0c82208a3b5a53a43e21859f1d98c38691e25b3ca30fbbcfa1dade3a9566e0ac"
    sha256 cellar: :any,                 sonoma:         "a7aafd8faf396255ef7d76bfa54a9ceb285d5eae3480c596d3148225ff89eb46"
    sha256 cellar: :any,                 ventura:        "315c730fe66178c8a2a902526e5c1cff10ec8ba87d164631580ad02d4eedc7c4"
    sha256 cellar: :any,                 monterey:       "89f2eeec08fe9f062a5c2381e797fef636828b92caf2263c4926693d4b5b0637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed503cd693f8dfcc77ac03e6ea4d718eb9b5e317bd1176c2de360a114f004fc9"
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
  depends_on "tbb"
  depends_on "webp"

  uses_from_macos "zlib"

  # https:github.comAcademySoftwareFoundationOpenImageIOblobmasterINSTALL.md
  fails_with :gcc do
    version "5"
    cause "Requires GCC 6.1 or later"
  end

  def python3
    "python3.12"
  end

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = prefixLanguage::Python.site_packages(python3)

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
                 shell_output("#{bin}oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    assert_match version.major_minor_patch.to_s, pipe_output(python3, output, 0)
  end
end