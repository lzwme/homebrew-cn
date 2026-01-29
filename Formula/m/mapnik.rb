class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://ghfast.top/https://github.com/mapnik/mapnik/releases/download/v4.2.1/mapnik-v4.2.1.tar.bz2"
  sha256 "5828695831cfac09b5d5e660c6c0747f0f447c7356b183b26fbed3e220456b33"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "d2bafb731202bf3758da4fbc409ea1ba8583ae81a4fc781169d8d9e58b526035"
    sha256                               arm64_sequoia: "23e0b8e12842dd640a6dc6c7b647018f9f866634fc68a3bd83a414aa80b6b200"
    sha256                               arm64_sonoma:  "ceca1d0b4d4aa18fe973d25229be2a6ab2ddd887ddeb686482e503f59a4ed407"
    sha256 cellar: :any,                 sonoma:        "c08c91d7f2a4d41ff43bb6e4fde8ecd91fcc26b20fe2938a81c8ed4e385f56c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a1e65f75a9605eba113429d7a6ab7f0f335c9e81c79f2b2afd743148e357d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2bdfbbdc4ce262883e819a2275cc3d628f1adc1eb91ac9fa60b7bf99aa491d2"
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