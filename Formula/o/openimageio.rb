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
    sha256 cellar: :any,                 arm64_tahoe:   "3a2ec3968e5fde528d08ee536d8bff65840e0375f4bf5be0bc6645d0cbcc6c12"
    sha256 cellar: :any,                 arm64_sequoia: "d3fec18063cc0e9024718dc239fe72096952d0c80c824b21f9156ab9ba554b5e"
    sha256 cellar: :any,                 arm64_sonoma:  "fb5b3e18db0332fe4add5ad2739fa648e11ee53154b52c662d59d53a55fe01e1"
    sha256 cellar: :any,                 sonoma:        "a319d0ba0e5146718d0d2f9d3e9162976459639235365b8446e14ceafde2fd6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6411860381b65615bf0f36a65f59005caf89f28aa7f9d276d101f9e1c64f2f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c7d99273142f9f31647764ed310413b56a37a40ab68101b979e6f9311fdf03"
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

  uses_from_macos "zlib"

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