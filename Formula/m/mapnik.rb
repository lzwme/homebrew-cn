class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https:mapnik.org"
  # needs submodules
  url "https:github.commapnikmapnik.git",
      tag:      "v4.0.3",
      revision: "e7a2bacb5d70f9c5fe0941906ce19137c0928522"
  license "LGPL-2.1-or-later"
  head "https:github.commapnikmapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "86a1973107192483e56afc52bd35816bf01e26b3a1ef7807ab3b1c435e42be33"
    sha256 cellar: :any,                 arm64_sonoma:  "7f37bbd2fb8eea6e916bc61a095b565d4accc6e069fa1e972176c64601e7b263"
    sha256 cellar: :any,                 arm64_ventura: "f2bb49b9b0b0d309602ce583fd2995fc78f39a20362cad393ab94fd02906e79e"
    sha256 cellar: :any,                 sonoma:        "6456dd2ae519b7fdc9fb4e7af4772f58f79a03b479883b03d684c9fc72d328ad"
    sha256 cellar: :any,                 ventura:       "38e56462fc630947acced5aa2be34012c3508b432e766087222a24c6ae5625a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85f85edaee90e4360c626aac4bf85dc5077348c4ce5b7a759134c457a4ba27c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@76"
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