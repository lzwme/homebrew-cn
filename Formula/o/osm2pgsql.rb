class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://ghproxy.com/https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/1.9.2.tar.gz"
  sha256 "dc30a3ad9a27f944e4169be9a8e07ee09711901536ddc8fcf4a292bd3aec51d9"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "436c3d5c461fca43f027f009280afba593f1633a67ed7754f476425e188c8a29"
    sha256 arm64_ventura:  "5848e72a69755241e67871c366871088a0dc2ecd5efbe6efd3a52cc55ac81007"
    sha256 arm64_monterey: "dbe9dfa5082b67b270de05f371a9d1891f61b094a1f9bd42be5b9eed8e36d221"
    sha256 sonoma:         "2927a5db93d925b946e2d6aa5b2ca5bd5ecb9c3825ea36593b79ca83233446d3"
    sha256 ventura:        "a5d5939a7e1fddbebed0bcc87c6f8967ccd59df39439bdf34cd584664ef337dc"
    sha256 monterey:       "6634267d8fbec90d4f70b2e505f7cfa09a805569d8193fafe5dbcdfc1c11be3a"
    sha256 x86_64_linux:   "bdb1b326f7c147e4d9c82de1f3c7a93be1d64ccdd70edc8f337cbcf4f63d1ed4"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "libpq"
  depends_on "luajit"
  depends_on "proj"

  uses_from_macos "expat"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    args = %w[
      -DWITH_LUAJIT=ON
      -DUSE_PROJ_LIB=6
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Connecting to database failed: connection to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end