class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https:mapnik.org"
  # needs submodules
  url "https:github.commapnikmapnik.git",
      tag:      "v4.0.0",
      revision: "85801bd4028fa1cbffd9f7de4e2458bfc55e44bd"
  license "LGPL-2.1-or-later"
  head "https:github.commapnikmapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7cfb7dd093232bccb0e355ca39647f482153318278333ad58aa7afb711c6209b"
    sha256 cellar: :any,                 arm64_ventura:  "df8ea8fc3350cb1a7067ce94cc67b0f1b491e3a85117b415cf1f9bac2035dd94"
    sha256 cellar: :any,                 arm64_monterey: "bdeb878366d5c0a0bb869b9189d336755b46f75a0af8cdc69423e1fcdd39a885"
    sha256 cellar: :any,                 sonoma:         "b834a8ba4b4694b816612bec2c2a2ca41304cf0f32b975fd3d3dbcc294b88cdc"
    sha256 cellar: :any,                 ventura:        "9198b79e4bdcaba38e7567395450aa72c11441cadd00a8df4c83a018ef35a88e"
    sha256 cellar: :any,                 monterey:       "5ff00ec8942ceb8becac05f8243ba0b51c8170f0d4a633bda679d70b4bd00bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c133c069eeec60ee72ffdb033720b494f7a98a9b89038abf8f531a694802ed5"
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

  fails_with :gcc do
    version "14"
    cause "Fails to build with GCC 14 (https:github.commapnikmapnikpull4456)"
  end

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