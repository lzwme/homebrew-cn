class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://ghproxy.com/https://github.com/openstreetmap/osm2pgsql/archive/1.9.1.tar.gz"
  sha256 "a34b48f8d9f4d61e72e5fd9b3408c92439eea5ab2a6fb907fb9ad22866aa947c"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "08466c3b278f396ae091544c3d3cf380fb5d8f75da1f6f39225b0569c7320dfc"
    sha256 arm64_monterey: "5cb6eefb6d205a29ad813a096bebe4289fb3b31f509e1c76c3bbe20ef2fd9132"
    sha256 arm64_big_sur:  "42f10b9359893ad494afb1c665432549092d362c1865d3665c59f47620820c60"
    sha256 ventura:        "595477658b8cc3e63aebe3ace58a24d29cbc4047d2ab8bcd841aa808b20c0601"
    sha256 monterey:       "eb787565b8a7ef457e7caeb43b29372cfecaa2582285e392f3d3596928969ce4"
    sha256 big_sur:        "23f7add7eecbc4bab0882bc8f7684055a5ccc49d84d7fc75bb299fb3bc3e6c06"
    sha256 x86_64_linux:   "af955b1b2d0258fb1d959132871fd5a80eae024b37c074332e92708402dfe907"
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