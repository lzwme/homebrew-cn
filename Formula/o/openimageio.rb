class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https:openimageio.readthedocs.ioenstable"
  url "https:github.comAcademySoftwareFoundationOpenImageIOarchiverefstagsv3.0.0.3.tar.gz"
  sha256 "fe96d2f39435f1585fe2ede4279a303e2cef3b28df351e8331fed46bbb251f35"
  license "Apache-2.0"
  head "https:github.comAcademySoftwareFoundationOpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex((?:Release[._-])?v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3dcfaaab7fbe511652c4e718e7121d75efe6e9694aa1939e17008d8670c4a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "6e5b658cb32ad125868b923f1bd97a3176b6f857e0476c50ef339accc8559d91"
    sha256 cellar: :any,                 arm64_ventura: "8273d0bd6e7462281f4199555c6f340f4d39a8a395bcb1f5cb45f35a23db25b7"
    sha256 cellar: :any,                 sonoma:        "a3640ef6154510b4ec7691b3b8ee7c3fae6e8e6689b7280adfc7e0f79c9119b5"
    sha256 cellar: :any,                 ventura:       "a0242dfd3214ba4397b2e5de6f4063a5104f801d02c39735f809417e071d73ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7be30f32a79f8b0cf8e2a5a41b9b9022fc9506c9259263e0d58798af16f6e1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "ffmpeg"
  depends_on "fmt"
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
  depends_on "python@3.12"
  depends_on "tbb"
  depends_on "webp"

  uses_from_macos "zlib"

  # https:github.comAcademySoftwareFoundationOpenImageIOblobmainINSTALL.md
  fails_with :gcc do
    version "8"
    cause "Requires GCC 9.3 or later"
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

    output = <<~PYTHON
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    PYTHON
    assert_match version.major_minor_patch.to_s, pipe_output(python3, output, 0)
  end
end