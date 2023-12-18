class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https:osm2pgsql.org"
  url "https:github.comopenstreetmaposm2pgsqlarchiverefstags1.10.0.tar.gz"
  sha256 "33849d8edacbca5ab5492fed32ac954de14f92ab6b3028c03ef88bb7ab596d20"
  license "GPL-2.0-only"
  head "https:github.comopenstreetmaposm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "acea4b76321ad63f5affa3195e25e5e9a0886c3898ad2cfcc332dd40ed10e6a8"
    sha256 arm64_ventura:  "887cea8fa7662c42fc446c83f0689f25661945d10774d2b67b49bf52cb8d4576"
    sha256 arm64_monterey: "817db2821232b01527802db2b0317d686a93bc637149b809b3d0bb7205290aab"
    sha256 sonoma:         "8d69da6f7809ecaf82317392333c38331c1ada8cb306151a002cab913733b7f3"
    sha256 ventura:        "1999a41bd749f3a8736c19250466d6b7fc68d2d9c19888eb92b9f9bd2042daf6"
    sha256 monterey:       "1bb8a809e3cdc99249a637f08604f56ede736e6d5802a06afc7f978892f7501a"
    sha256 x86_64_linux:   "c342e5efe04ba8ab4a14cb4a99e9fcffc4ca046fdf77f632334bfe8d7bd5af49"
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