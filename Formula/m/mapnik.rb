class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.2.0",
      revision: "b806a6c64994eca7ec5b991c2e81471d89b81b1c"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd281e1f31f066cc8075673fa027dd132977273432cc131322906c191de810b5"
    sha256 cellar: :any,                 arm64_sequoia: "92246218dd3f2e7d75e9d4a3e14442f5d758fe419239fd20ccc1ce0d71b57c29"
    sha256 cellar: :any,                 arm64_sonoma:  "c472690d65e5479aa4c9e3837e778dc0e442c660818ff3db22f0f9e5fad7c05b"
    sha256 cellar: :any,                 sonoma:        "2050c55c0cce24ca0240559f6cd7cd710662021b3902557b77dc7c2442dd9f03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c7215f5d2b32df37cc4fc125cb0e9172a7698587dcfe06534fe4b9e7a5416ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88245d1ed1fe12273415968a5b24716abcfdc33422cd981e3902e7dd4888fef3"
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