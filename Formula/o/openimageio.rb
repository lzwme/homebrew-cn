class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.1.6.2.tar.gz"
  sha256 "a1e515e6a6ea9925a70c23db21dda37f3ce2c24780a6bfedd8685fea063f698a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "main"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ffd8e3cddfb8f1b272b04c5b95805d877d9e51867a8a2237fb5499c2961d7cba"
    sha256 cellar: :any,                 arm64_sequoia: "613d20b99cf49631bb052e4ec4744ad9ecad66762aad88380fd52a15412c52ca"
    sha256 cellar: :any,                 arm64_sonoma:  "69ec00589020d2119bfa4822dd5ecea966606fde870fd389084598c11b7bbf2e"
    sha256 cellar: :any,                 sonoma:        "87d812b539f867f0bfaa3e0d1111b6082f9230bc1918c481dd8446ce8f379939"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b45cf41935ba570f572e6553434e970971b443306443ec3e64218503a0c597e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b2f832f916e621ea1f665d355a8c6972e39cea164f0a4cf45326d0aaf294e7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "ffmpeg"
  depends_on "fmt" # needed for headers
  depends_on "freetype"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "pugixml"
  depends_on "python@3.14"
  depends_on "tbb"
  depends_on "webp"
  depends_on "zlib"

  # https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/main/INSTALL.md
  fails_with :gcc do
    version "8"
    cause "Requires GCC 9.3 or later"
  end

  def python3
    "python3.14"
  end

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = site_packages = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages/"OpenImageIO")}
      -DPython3_EXECUTABLE=#{which(python3)}
      -DPYTHON_VERSION=#{py3ver}
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DOIIO_BUILD_TESTS=OFF
      -DOIIO_INTERNALIZE_FMT=OFF
      -DUSE_DCMTK=OFF
      -DUSE_EXTERNAL_PUGIXML=ON
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
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

    output = <<~PYTHON
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    PYTHON
    assert_match version.major_minor_patch.to_s, pipe_output(python3, output, 0)
  end
end