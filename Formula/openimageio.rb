class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://ghproxy.com/https://github.com/OpenImageIO/oiio/archive/v2.4.12.0.tar.gz"
  sha256 "1576eb9b805998e684014688528c8e63958edba3a8b01073a10266b999f4c674"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "333c34b303f5ee2bb3818366d8b001eaba81bc836926b2792360e12c168b7790"
    sha256 cellar: :any,                 arm64_monterey: "16fd18adae2b8246b251e032f2bcb2439dbcfc3c244f980cda7ccbbf95ac77dd"
    sha256 cellar: :any,                 arm64_big_sur:  "ffdbcf283f25ad1ee2dd1a132a04d0d770a2b62628ea301126746d56ec0231cc"
    sha256 cellar: :any,                 ventura:        "3acbc86b5827ede2d1272c217b426f88e53a409919090acbea928e13d6350164"
    sha256 cellar: :any,                 monterey:       "7c5aba3aeb5d5d4df7b79583dbf99628370f5bb4163d96a0732a05c8403e9079"
    sha256 cellar: :any,                 big_sur:        "2be400166239b09c09abd26d3ade79cf4be42dd8c09937c0c3fd9084d88eeaf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e9a8a6ef331c16f1fb1fd7a6fc32cb6960d46dc2ddc29effa16bd5ebb595b94"
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