class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://ghfast.top/https://github.com/mapnik/mapnik/releases/download/v4.3.0/mapnik-v4.3.0.tar.bz2"
  sha256 "cec8c2bf2fd5f46be0fdb77469761a3ba1d51bea7b3c16b91875e9f89867d141"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "bdd9efe6ce637d8e4b150dbc1554ae8ccd82bf7a0d98e175b33493933f02ad1b"
    sha256               arm64_sequoia: "1593ef390b6eac1a9639b9a46caba61fdf9004ff227529664f668a44240a0242"
    sha256               arm64_sonoma:  "2fb51270ebd0049956e6b7946ea66d2343156946453fd4ed57e312d0c0daad03"
    sha256 cellar: :any, sonoma:        "2d83ac7b575ec4beccaac7a758c7f6fbddeae6d67ad5799e0db0ab775ea8485e"
    sha256 cellar: :any, arm64_linux:   "4b343f151c61a7cdfc6c0c75c0b4d88be4719b093397e3233fa2eca2621effb4"
    sha256 cellar: :any, x86_64_linux:  "2395b775ad201c77d9304babfd2f6c2ade97d6a20bd492a7b74b0ef74bbe284d"
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