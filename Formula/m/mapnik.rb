class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https:mapnik.org"
  # needs submodules
  url "https:github.commapnikmapnik.git",
      tag:      "v4.0.2",
      revision: "5f327ff3c88d8acca7c5db15b598258eea363aa7"
  license "LGPL-2.1-or-later"
  head "https:github.commapnikmapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "26640f552d65f93b7945a55e0869f5c2d05becab2b5b0784c41982a77503e8f0"
    sha256 cellar: :any,                 arm64_sonoma:   "a08567fab792639725b4e49a52bdadd453663dd6382e425e2543dc488dfa6ffc"
    sha256 cellar: :any,                 arm64_ventura:  "4a63b043bf14cfd50a5542e8675241c6688914fe04e36fe8b07404f2844bbb42"
    sha256 cellar: :any,                 arm64_monterey: "4f6dce463d60991c23de3f2671167a17b00b14293a431506211b5e4afd804803"
    sha256 cellar: :any,                 sonoma:         "5f94034082640323ab30dd80bc312e15f1bbec7478b0bd4a4581c0a62b50eec1"
    sha256 cellar: :any,                 ventura:        "2b99f0190fb783e7ebaa4a447c476dacb0d33ae331e22160009e2b44f7997cf4"
    sha256 cellar: :any,                 monterey:       "52f154e3437dc9ab1970833bd7fe3ef62bb8cf8015d5c7f234c65d248714a8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fecb83093c9547b2ead8be587b08d124fd7f98db62971d972f550edcef96dd6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c"
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
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_BENCHMARK:BOOL=OFF"
    cmake_args << "-DBUILD_DEMO_CPP:BOOL=OFF"
    cmake_args << "-DBUILD_DEMO_VIEWER:BOOL=OFF"
    cmake_args << "-DCMAKE_INSTALL_RPATH:PATH=#{rpath}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkg-config"].bin}pkg-config libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end