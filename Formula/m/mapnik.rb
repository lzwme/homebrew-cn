class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.4",
      revision: "d4c7a15bc235b986fa80255cae0df9784c8b78c6"
  license "LGPL-2.1-or-later"
  revision 3
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b098625289ad8d7a1e98bdbfb0cb49fff42815826fec65696171c4d19dbd119c"
    sha256 cellar: :any,                 arm64_sequoia: "dc380371545f85c6c7de9df8039c2ab8f7c051f229b0b862414c6ad30bf1c81a"
    sha256 cellar: :any,                 arm64_sonoma:  "03c408694f4837163c3e40f069e17b14bfd99a021307ad80f9b870e3c0800e30"
    sha256 cellar: :any,                 sonoma:        "fe107cadb5cf4a7b5fa95d484d2f180a5a44da4a85fb662537f400f22b9aa5f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfa115c1eec76b7ec2aa0a406214545425d362409f37f354d223bcd29be9ad37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35de85f5214c6692972509e4026314e6646789ec1ea520985b357709b3aff285"
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