class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://ghproxy.com/https://github.com/OpenImageIO/oiio/archive/v2.4.10.0.tar.gz"
  sha256 "59f523a0b9a1014993bedcf7752993af43b348761165f52ea6eb84787f57aed5"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/OpenImageIO/oiio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2ca58e8514363a2b7193cfad8a63bb8d4c3cd80f285205b2ea081ead6f2be993"
    sha256 cellar: :any,                 arm64_monterey: "2be78bbaaa4bf57b82c35f7a240ce476d91565b2f339c2b73935dc3a093c4be5"
    sha256 cellar: :any,                 arm64_big_sur:  "493648ca4943295b08d93cee0f9aab9ab3eb8d40efe598b9aea2f36282839a07"
    sha256 cellar: :any,                 ventura:        "554c81c3b6081a43508d67027161eee06851f457d23a4316b0f7c797ac079539"
    sha256 cellar: :any,                 monterey:       "00a0cf546cf3cc14eba5427010d4026cdb98b98053b93af30db254c1e3450c30"
    sha256 cellar: :any,                 big_sur:        "41587a3a94b154d8759d300c080b5f2e22ae2435a6a284c81b4496eacf10af1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4968e17677524170b6ea4e19d60457a6d4610fcf91de1640aeda886de5aa891f"
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