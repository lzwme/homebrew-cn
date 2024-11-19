class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https:osm2pgsql.org"
  url "https:github.comopenstreetmaposm2pgsqlarchiverefstags2.0.0.tar.gz"
  sha256 "05c2355b4a59d03a0f9855b4234a3bdc717b078faee625e73357947d1a82fe89"
  license "GPL-2.0-only"
  head "https:github.comopenstreetmaposm2pgsql.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "ffea3cae27bf62d48968eb9be4ab85440e60fa216231855c97a68ed4e42b8219"
    sha256 arm64_sonoma:  "b6f235dacd6ba9a51d383689d1b632445108ec701f89793bf40c4e6a55e856b9"
    sha256 arm64_ventura: "07994b3ea37df9184ad633a9d0a30a571ec4f5e4b07497106a5182797ff455e2"
    sha256 sonoma:        "1fe7f0b34eeec3f80bf76bb57df61afb08a4018c20234e6b46de2a1bf9e7abc0"
    sha256 ventura:       "85d2ace7b9134fdfaf2cd64d9ee9c269796524b8aef5e5cd659e1b11401d3a2e"
    sha256 x86_64_linux:  "574cff38f797341afc455c8d7ee5a996d2ebe376214f38a578f4a79e260d52a7"
  end

  depends_on "boost" => :build
  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "libosmium" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build

  depends_on "libpq"
  depends_on "luajit"
  depends_on "proj"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(\d\.\d)
    inreplace "cmakeFindLua.cmake", set\(LUA_VERSIONS5( \d\.\d)+\),
                                     "set(LUA_VERSIONS5 #{lua_version})"

    # Remove bundled libraries
    rm_r("contrib")

    args = %W[
      -DEXTERNAL_CLI11=ON
      -DEXTERNAL_FMT=ON
      -DEXTERNAL_LIBOSMIUM=ON
      -DEXTERNAL_PROTOZERO=ON
      -DPROTOZERO_INCLUDE_DIR=#{Formula["libosmium"].opt_libexec}include
      -DWITH_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}osm2pgsql devnull 2>&1", 1)
    assert_match "ERROR: Connecting to database failed", output

    assert_match version.to_s, shell_output("#{bin}osm2pgsql --version 2>&1")
  end
end