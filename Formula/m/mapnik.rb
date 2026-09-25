class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://ghfast.top/https://github.com/mapnik/mapnik/releases/download/v4.3.2/mapnik-v4.3.2.tar.bz2"
  sha256 "1858a9d57f4d2007d717ea84af23bcb32bd984fbc635426b79124fe9f7a682c4"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "382b770e37078a58bfe5a1984e2944b62a9c483d48a9b4d5bf85679046087611"
    sha256 cellar: :any, arm64_tahoe:       "acbeae8ddc75a6d34ec2e6c8c41e7d072944f746290e23f817e4c6782670fe36"
    sha256 cellar: :any, arm64_sequoia:     "38e4be5ff7a850f629aff3a4a8f2bd7a92d1e4c226d3095d1d66aeec6f7ceff7"
    sha256 cellar: :any, arm64_linux:       "7b03a861716b3ad636702f883a28f38dba6ac2a93ff1cf61a483047f8ea9ed22"
    sha256 cellar: :any, x86_64_linux:      "772e16eb8a3ac45517d6c703a3d7baeeec7e5edd42ab844fbd15f724c5b99372"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "svg2png", because: "both install `svg2png` binaries"

  def install
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath};#{rpath(source: lib/"mapnik/input")}
      -DUSE_EXTERNAL_MAPBOX_PROTOZERO=ON
    ]

    # TODO: Remove this workaround once either:
    # a) CMake in mapnik properly handles C language requirements for proj OR
    # b) The workaround is no longer needed with proj > 9.9.0
    #    Ref: https://github.com/OSGeo/PROJ/issues/4862
    inreplace "CMakeLists.txt", "LANGUAGES CXX\n", "LANGUAGES C CXX\n"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end