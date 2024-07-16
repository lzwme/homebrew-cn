class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https:openimageio.readthedocs.ioenstable"
  url "https:github.comAcademySoftwareFoundationOpenImageIOarchiverefstagsv2.5.13.1.tar.gz"
  sha256 "0fbaec6c15215e11cf4545128c4d64eaa97b461cb9b5fb8a76f9a7d35c99e3df"
  license "Apache-2.0"
  head "https:github.comAcademySoftwareFoundationOpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex((?:Release[._-])?v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79d37ba795824594fe3c6b9103b7087b8b93ab013f81f1a3f821b6c706d0b751"
    sha256 cellar: :any,                 arm64_ventura:  "fd696ec9f4a4c86b0983d82327b4c0096e84c656b5baaaed28b782a468dc17bf"
    sha256 cellar: :any,                 arm64_monterey: "772cf6b7ad87f5be76a7a7b019a39a4d8588b6ab7fb42bdd13a78be542420acd"
    sha256 cellar: :any,                 sonoma:         "d387fac604d78a86d74930445e6cd4d8984cc0b63f5b404d3a18c17cfe2240da"
    sha256 cellar: :any,                 ventura:        "c3ce054956bdacfa0128c2edce5d0c6156b88def6c2a637c6fe5e47465ed7b0a"
    sha256 cellar: :any,                 monterey:       "95b365bc35757ed65d967c16e25140c74fe0a6896800fd1c03259016f49529b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "643f4a13a98b622169f0b118cff3d2b7ca8d74d5fce5ad853d921d09a9f7adc0"
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