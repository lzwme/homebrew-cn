class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https:mapnik.org"
  # needs submodules
  url "https:github.commapnikmapnik.git",
      tag:      "v4.0.7",
      revision: "d9d4288bea04c5ef9925c03db353cf5f308e06ad"
  license "LGPL-2.1-or-later"
  revision 2
  head "https:github.commapnikmapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "29a822426649d23d451319bd0e8a97ca73befc6b26b2643cabd9ed6aea578e8a"
    sha256 cellar: :any, arm64_sonoma:  "a078278f51be82e77b0392328a77750f8b3d10aa506ba953a3182a90b7a06d0a"
    sha256 cellar: :any, arm64_ventura: "2aa1748de65ed49fcbdc2f2483e1933e9238d5d08f23f0e199334de7e10efee1"
    sha256 cellar: :any, sonoma:        "44dd1ff51b0290cda60df185e662717209a8b7d0eadd05da7d6df429d521fddb"
    sha256 cellar: :any, ventura:       "83221debd01d9073623d4b84cfce8d28dd76ee9199333130eabc2c0685d640a9"
    sha256               arm64_linux:   "d4fb224d070a7cd94e3c17674e16c39a9c7d07293bdb5c7115f75a3b1a82fa57"
    sha256               x86_64_linux:  "344607e36fe3ed140f6eda570637cf093c1abbca17dfa541efa01a15e04672fa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  conflicts_with "osrm-backend", because: "both install Mapbox Variant headers"
  conflicts_with "svg2png", because: "both install `svg2png` binaries"

  def install
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkgconf"].bin}pkgconf libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end