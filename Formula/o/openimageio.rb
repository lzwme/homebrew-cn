class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.0.9.1.tar.gz"
  sha256 "bbc5db069b7d8e4e2fccf994d55a262953057745a5e398e44a2e5235a8736d1d"
  license "Apache-2.0"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "824722bf41c2be14bd6b5edb08fdec07f05c8da79e560e7505d94193fd77638a"
    sha256 cellar: :any,                 arm64_sonoma:  "16adaa221d65f69b2c8ef0e8b4fd92a548f817e2c3bc10a2a07135f57527bdbd"
    sha256 cellar: :any,                 arm64_ventura: "41e7c2f4e2d26fbcb0dec5ebb7b4a5532c195f134c52cfd5044280bc2d7ba21f"
    sha256 cellar: :any,                 sonoma:        "6cccd088d46549e5515ef5a217532ef8edb7ddc6828a99d96b159716af96dc18"
    sha256 cellar: :any,                 ventura:       "8108c099647904dcaa5e2159c7509b893340b39b7d72ca40942ea51df9bdbe22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae5fe6c3fc7571dc5d40d057ab6c4096904974314666774c149dce5be3b27f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a5deca8630e4b1f28253507ea0e89291c6bdf87cbc399ebc74b505898681212"
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