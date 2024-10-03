class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https:openimageio.readthedocs.ioenstable"
  url "https:github.comAcademySoftwareFoundationOpenImageIOarchiverefstagsv2.5.16.0.tar.gz"
  sha256 "e5438e28d34a5b0a09428ed77ec310edd47c141db1b259364859110847e161e7"
  license "Apache-2.0"
  revision 1
  head "https:github.comAcademySoftwareFoundationOpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex((?:Release[._-])?v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bdd3123fa0c9b7328cf05c6ae94a618701ca2722935203aca3f0284b63fdfecd"
    sha256 cellar: :any,                 arm64_sonoma:  "00dc8103f37626467cbfc243e3e83d0bf21f26eb3b42373362333a22e86734a7"
    sha256 cellar: :any,                 arm64_ventura: "5f59bd6438eddc7cd8a3f3d14560c84320095abefb30fdf3e35a1f54462f4d2c"
    sha256 cellar: :any,                 sonoma:        "da23543e8acaeb10e1e984801cea19443a62fdabe5a92214ac44a59fdf1cce79"
    sha256 cellar: :any,                 ventura:       "35f1682488c0a90be472e73e83e4ada611f5ece7f535b7af3a98c8249dd2157c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b78f6ae83f5d072a29a9f3180275b8566fab9caaf35483dd95c5c6a55c8c20"
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