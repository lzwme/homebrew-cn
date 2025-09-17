class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.0.10.0.tar.gz"
  sha256 "c424637af66fc6d04f202156c3f7cf4a5484ccbe07966d3d8a1fde27c7472721"
  license "Apache-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "main"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff60ffc013fc2ed1d518b005853b5e1f3312b5b20dc444d7439c237e1f3b84cd"
    sha256 cellar: :any,                 arm64_sequoia: "c157baf2ca35711361f1343ae3335b4d1230ea19e31baf2852abbea084aa028a"
    sha256 cellar: :any,                 arm64_sonoma:  "9e324feb990af0a04baa3541e5b285bc123eccd1aeed8af7f81b80d786073720"
    sha256 cellar: :any,                 arm64_ventura: "f0a6126c4ddd760b49bbe7c66e6d0a63c9240f6aca87288062bc0d0c61bf296d"
    sha256 cellar: :any,                 sonoma:        "1c137cc92ffe05ce3caedf48033d9d836c9a9188418f0bba64736701571dea02"
    sha256 cellar: :any,                 ventura:       "697dda3787cbcbda48fec4555ad37949576a51d0aaf05cd314ec44df22fb907c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e571e09ff02dcd30a9482d044482390ec11c3304d8b2cfd2f7ff208739975dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d47d6f7820cec31fbf71b90321185ff5d324b089e1971cf4308b79ac67d554"
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
  depends_on "python@3.13"
  depends_on "tbb"
  depends_on "webp"

  uses_from_macos "zlib"

  # https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/main/INSTALL.md
  fails_with :gcc do
    version "8"
    cause "Requires GCC 9.3 or later"
  end

  def python3
    "python3.13"
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