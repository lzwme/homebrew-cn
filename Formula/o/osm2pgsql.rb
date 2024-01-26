class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https:osm2pgsql.org"
  url "https:github.comopenstreetmaposm2pgsqlarchiverefstags1.10.0.tar.gz"
  sha256 "33849d8edacbca5ab5492fed32ac954de14f92ab6b3028c03ef88bb7ab596d20"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comopenstreetmaposm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "edf6959f2d4c4b6c870525d5331f66399e548c6dc061b25be2e986ed10df38ed"
    sha256 arm64_ventura:  "d87a68fdb44dedfba0182e60f9aca845198b5e09a365e68621990870aa72fe07"
    sha256 arm64_monterey: "db6e787a256448825721efbe5a1e283afe29d18b3aa97050ba6a6868747de5fc"
    sha256 sonoma:         "e6dc0aa01de095bf0fc3bc47ae947b3e6ff30b63ef9fecc72b12c45b1bad4b4f"
    sha256 ventura:        "1d1a1b7743d6f0ad69c8b55278b246d29e61a89cbc4eb20aa0002c6bf19e880d"
    sha256 monterey:       "712663e47fcc94da88f28d7511828e974bb02173c6dce81ec26a005824a24c05"
    sha256 x86_64_linux:   "e575f36b6070639c4e20ca5ba38b94f0f2fff0092bbdf97bb4904cf8953f9388"
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
    lua_version = Formula["lua"].version.to_s.match(\d\.\d)
    inreplace "cmakeFindLua.cmake", set\(LUA_VERSIONS5( \d\.\d)+\),
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
                 shell_output("#{bin}osm2pgsql devnull 2>&1", 1)
  end
end