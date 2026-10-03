class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v3.2.1.0.tar.gz"
  sha256 "380d6c8de80de603989fe85e4f128e658517bc20d2db3b52ed5c14afb39648e3"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "main"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "89ed66aa96de8ce41e9d6924cfac5dd63d9c12b78e40dd1c815e9bd9f902b4e7"
    sha256 cellar: :any, arm64_tahoe:       "573ba703a262a16c52e219a89477f318f3abff87a4ca647918c99c970b8b161a"
    sha256 cellar: :any, arm64_sequoia:     "232aa9066191eccd093181a40cbdc299974c5fe3ba74f14b8640b5989f0976dc"
    sha256 cellar: :any, arm64_linux:       "e7004226062089be17b6d9c1c73b3e93fb7ae4dc8e2e68debde42bb74b07a42b"
    sha256 cellar: :any, x86_64_linux:      "77cce8d9cd31a7486813cfe346791a246f34cc747e0f2b46217823a1ecf5b1ff"
  end

  depends_on "cmake" => :build
  depends_on "nanobind" => :build
  depends_on "pkgconf" => :build
  depends_on "robin-map" => :build
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
  depends_on "zlib-ng-compat"

  # https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/main/INSTALL.md
  fails_with :gcc do
    version "8"
    cause "Requires GCC 9.3 or later"
  end

  deny_network_access!

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = site_packages = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages/"OpenImageIO")}
      -DPython3_EXECUTABLE=#{python3}
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