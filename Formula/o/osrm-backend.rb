class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  url "https://ghfast.top/https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v26.8.0.tar.gz"
  sha256 "793c1b6335bdd56fe3207267c63490cf0b462aed2765fd747c297ada494ff188"
  license "BSD-2-Clause"
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e7434b720b33a53ac46bc87f26882c175dec68bf6461fd11a927b5ec6e399a56"
    sha256 cellar: :any, arm64_sequoia: "77309b97db32b785e3502ff6ffeb82ef199810c7e6bd18aefdc788f04638811b"
    sha256 cellar: :any, arm64_sonoma:  "22feed5addd30221d4ecd1e78e7eb4b5a379b4d10057dec65b1a3549264e8407"
    sha256 cellar: :any, sonoma:        "b2f0260385e85a6bb61f229a0695982e63be1ae6220a4917f47caab40438bafe"
    sha256 cellar: :any, arm64_linux:   "e0f7b0d25044710ab308c15f82876163b730ffc69ec127e03ad10b0942b5a937"
    sha256 cellar: :any, x86_64_linux:  "ad49f6da88d3395b06f61029d864a386e73f700f1438a950514ff5cdcc1f5f0c"
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "fmt" => :build
  depends_on "libosmium" => :build
  depends_on "pkgconf" => :build
  depends_on "protozero" => :build
  depends_on "rapidjson" => :build
  depends_on "sol2" => :build
  depends_on "vtzero" => :build

  depends_on "boost"
  depends_on "libarchive"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1600
    cause "Requires C+++20 support for `std::atomic_ref`"
  end

  fails_with :gcc do
    version "11"
    cause <<~CAUSE
      /usr/include/c++/11/type_traits:987:52: error: static assertion failed: template argument must be a complete class or an unbounded array
        static_assert(std::__is_complete_or_unbounded(__type_identity<_Tp>{}),
    CAUSE
  end

  def install
    lua = Formula["lua"]
    luaversion = lua.version.major_minor

    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CCACHE:BOOL=OFF",
                    "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua#{luaversion}",
                    "-DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua", luaversion.to_s)}",
                    "-DENABLE_GOLD_LINKER=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "profiles"
  end

  test do
    node1 = 'visible="true" version="1" changeset="676636" timestamp="2008-09-21T21:37:45Z"'
    node2 = 'visible="true" version="1" changeset="323878" timestamp="2008-05-03T13:39:23Z"'
    node3 = 'visible="true" version="1" changeset="323878" timestamp="2008-05-03T13:39:23Z"'

    (testpath/"test.osm").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6">
       <bounds minlat="54.0889580" minlon="12.2487570" maxlat="54.0913900" maxlon="12.2524800"/>
       <node id="1" lat="54.0901746" lon="12.2482632" user="a" uid="46882" #{node1}/>
       <node id="2" lat="54.0906309" lon="12.2441924" user="a" uid="36744" #{node2}/>
       <node id="3" lat="52.0906309" lon="12.2441924" user="a" uid="36744" #{node3}/>
       <way id="10" user="a" uid="55988" visible="true" version="5" changeset="4142606" timestamp="2010-03-16T11:47:08Z">
        <nd ref="1"/>
        <nd ref="2"/>
        <tag k="highway" v="unclassified"/>
       </way>
      </osm>
    XML

    (testpath/"tiny-profile.lua").write <<~LUA
      function way_function (way, result)
        result.forward_mode = mode.driving
        result.forward_speed = 1
      end
    LUA

    safe_system bin/"osrm-extract", "test.osm", "--profile", "tiny-profile.lua"
    safe_system bin/"osrm-contract", "test.osrm"
    assert_path_exists testpath/"test.osrm.names", "osrm-extract generated no output!"
  end
end