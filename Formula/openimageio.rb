class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://ghproxy.com/https://github.com/OpenImageIO/oiio/archive/v2.4.11.1.tar.gz"
  sha256 "3199981a0b239229181b1769721b661506cc1e1fb0fed5d1b382d7ec64e269fb"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a3694cd87b4e563d0b6bc7c2adb31845a6fec8a57dfec3552c6744bd6b9fcc1"
    sha256 cellar: :any,                 arm64_monterey: "0ec279cdfe9fe9a648ddbc325412e76a0ff73cb90e20e5e569567a538c28dffe"
    sha256 cellar: :any,                 arm64_big_sur:  "79ca3abb2dc13248873535b84fa594a0cf6a511f3f897630f474b6cee43b3566"
    sha256 cellar: :any,                 ventura:        "593dfe787afa87b73a569d7fd7cc41952cd18ab80451b3d6ca39390aa44fe8b9"
    sha256 cellar: :any,                 monterey:       "7cbe462e7efcba8bd0348a8a005cbaa637bca763d6dbf027e880ec1035c52f58"
    sha256 cellar: :any,                 big_sur:        "9d4653a305640cd0a864cf6dee2e6642e9bf2b8b439dcb2ff9972c22c79a780d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a61ec90045ebcb67085f91fe0fba6f5fef5f899bc17c43d3797ed99aec98c5b"
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