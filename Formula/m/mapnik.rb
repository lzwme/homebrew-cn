class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.4",
      revision: "d4c7a15bc235b986fa80255cae0df9784c8b78c6"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "dc4d7089a624297156600a65bc8e9d1cf4b322579cc958c447bdc29e4fd083ff"
    sha256 cellar: :any,                 arm64_sequoia: "1e566e98261203daf685a6414659b4c911f84ac6edbd39a7a5c187bf04c09dc4"
    sha256 cellar: :any,                 arm64_sonoma:  "4174de625ddaf32981840c0774b0274066d08d950dfc897504d0a7ce92090c83"
    sha256 cellar: :any,                 sonoma:        "9113db10f6b975eb45bd0d70d467d9d7f89b10d635fbab8ad31a2c769e515392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98fc74497f202c7ce63076d2f7855256514d78f0f792f8fc9c37ee83652910b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5643feda9260b5bd9ee06dfa39cc4ff911f1524914f2642c58ca0947c1d2dd6a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "protozero"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  conflicts_with "svg2png", because: "both install `svg2png` binaries"

  def install
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath}
      -DUSE_EXTERNAL_MAPBOX_PROTOZERO=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkgconf"].bin}/pkgconf libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end