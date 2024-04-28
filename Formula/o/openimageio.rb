class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https:openimageio.readthedocs.ioenstable"
  url "https:github.comAcademySoftwareFoundationOpenImageIOarchiverefstagsv2.5.10.1.tar.gz"
  sha256 "8f6a547f6a5d510737ba436f867043db537def65f0fdb14ec30e5a185b619f93"
  license "Apache-2.0"
  revision 2
  head "https:github.comAcademySoftwareFoundationOpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex((?:Release[._-])?v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bbb2ba98d3a2256cd8b8f442a0b00b433d03e84d0d119e896cab2e64c2fba43"
    sha256 cellar: :any,                 arm64_ventura:  "436233b2e3e979edb1bb628991ddfeb784ec312a93e12e2184b70375db69d753"
    sha256 cellar: :any,                 arm64_monterey: "1d5f4324661fb3d7abd6428712544988fd353500fbd7629ade7afb8a84436276"
    sha256 cellar: :any,                 sonoma:         "a65ff6993a1eba5160094077cfda20c8161cc0076bb0243832754db4a5646ea3"
    sha256 cellar: :any,                 ventura:        "68da31cb49b47ed52466355b3a92a41b24cd787b1a2604fa221699630e45da43"
    sha256 cellar: :any,                 monterey:       "05d451a55de6170b989c63a07bd3cd433d48ef8531643863da5f6849fd8643d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689594e04055c7ee60bbea0c3560af83ce5bc31711596c7ffbb9dedeafa9c6a1"
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