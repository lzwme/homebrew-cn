class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https:project-osrm.org"
  license "BSD-2-Clause"
  revision 7
  head "https:github.comProject-OSRMosrm-backend.git", branch: "master"

  # TODO: Remove `conflicts_with "mapnik"` in release that has following commit:
  # https:github.comProject-OSRMosrm-backendcommitc1ed73126dd467171dc7adb4ad07864909bcb90f
  stable do
    url "https:github.comProject-OSRMosrm-backendarchiverefstagsv5.27.1.tar.gz"
    sha256 "52391580e0f92663dd7b21cbcc7b9064d6704470e2601bf3ec5c5170b471629a"

    # Backport fix for Boost 1.85.0. Remove in the next release.
    # PR ref: https:github.comProject-OSRMosrm-backendpull6856
    patch do
      url "https:github.comProject-OSRMosrm-backendcommit10ec6fc33547e4b96a5929c18db57fb701152c68.patch?full_index=1"
      sha256 "4f475ed8a08aa95a2b626ba23c9d8ac3dc55d54c3f163e3d505d4a45c2d4e504"
    end

    # Backport fix for missing include. Remove in the next release.
    # Ref: https:github.comProject-OSRMosrm-backendcommit565959b3896945a0eb437cc799b697be023121ef
    #
    # Also backport sol2.hpp workaround to avoid a Clang bug. Remove in the next release
    # Ref: https:github.comProject-OSRMosrm-backendcommit523ee762f077908d03b66d0976c877b52adf22fa
    #
    # Also add diff from open PR to support Boost 1.87.0
    # Ref: https:github.comProject-OSRMosrm-backendpull7073
    patch :DATA
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21aa25fa7a3562fcfe9d8a0ae47ecaf39dc96a129fe4335f84a2bb45bce9c5bd"
    sha256 cellar: :any,                 arm64_sonoma:  "95139386132a79afbf03c241e3bc94b20aba6b4a1b73674a3887be3f4810b229"
    sha256 cellar: :any,                 arm64_ventura: "6bd26f9a7d81c614e8da57f44b036d9399f27b02780cd7f1e5fc240958e9c694"
    sha256 cellar: :any,                 sonoma:        "da566a8ea2bd4625ac39fb6be072ad44b2e98e1114f47e4dd21ed76f0218e52e"
    sha256 cellar: :any,                 ventura:       "4fb6126c266f179069dd0b8f159baa07fd14aab2f99f10b812448dea27a291db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae7b39121c03728fa24a88578072dcc1a0bed6aacc6fb60c51eb0f3b651d064"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "flatbuffers", because: "both install flatbuffers headers"
  conflicts_with "mapnik", because: "both install Mapbox Variant headers"

  def install
    # Work around build failure: duplicate symbol 'boost::phoenix::placeholders::uarg9'
    # Issue ref: https:github.comboostorgphoenixissues111
    ENV.append_to_cflags "-DBOOST_PHOENIX_STL_TUPLE_H_"
    # Work around build failure on Linux:
    # tmposrm-backend-20221105-7617-1itecwdosrm-backend-5.27.1srcosrmosrm.cpp:83:1:
    # usrincludec++11extnew_allocator.h:145:26: error: 'void operator delete(void*, std::size_t)'
    # called on unallocated object 'result' [-Werror=free-nonheap-object]
    ENV.append_to_cflags "-Wno-free-nonheap-object" if OS.linux?

    lua = Formula["lua"]
    luaversion = lua.version.major_minor

    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CCACHE:BOOL=OFF",
                    "-DLUA_INCLUDE_DIR=#{lua.opt_include}lua#{luaversion}",
                    "-DLUA_LIBRARY=#{lua.opt_libshared_library("liblua", luaversion.to_s)}",
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

    (testpath"test.osm").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6">
       <bounds minlat="54.0889580" minlon="12.2487570" maxlat="54.0913900" maxlon="12.2524800">
       <node id="1" lat="54.0901746" lon="12.2482632" user="a" uid="46882" #{node1}>
       <node id="2" lat="54.0906309" lon="12.2441924" user="a" uid="36744" #{node2}>
       <node id="3" lat="52.0906309" lon="12.2441924" user="a" uid="36744" #{node3}>
       <way id="10" user="a" uid="55988" visible="true" version="5" changeset="4142606" timestamp="2010-03-16T11:47:08Z">
        <nd ref="1">
        <nd ref="2">
        <tag k="highway" v="unclassified">
       <way>
      <osm>
    XML

    (testpath"tiny-profile.lua").write <<~LUA
      function way_function (way, result)
        result.forward_mode = mode.driving
        result.forward_speed = 1
      end
    LUA

    safe_system bin"osrm-extract", "test.osm", "--profile", "tiny-profile.lua"
    safe_system bin"osrm-contract", "test.osrm"
    assert_predicate testpath"test.osrm.names", :exist?, "osrm-extract generated no output!"
  end
end

__END__
diff --git aincludeextractorsuffix_table.hpp bincludeextractorsuffix_table.hpp
index 5d16fe6..2c378bf 100644
--- aincludeextractorsuffix_table.hpp
+++ bincludeextractorsuffix_table.hpp
@@ -3,6 +3,7 @@

 #include <string>
 #include <unordered_set>
+#include <vector>

 #include "utilstring_view.hpp"

diff --git athird_partysol2-3.3.0includesolsol.hpp bthird_partysol2-3.3.0includesolsol.hpp
index 8b0b7d36ea4ef2a36133ce28476ae1620fcd72b5..d7da763f735434bf4a40b204ff735f4e464c1b13 100644
--- athird_partysol2-3.3.0includesolsol.hpp
+++ bthird_partysol2-3.3.0includesolsol.hpp
@@ -19416,7 +19416,14 @@ namespace sol { namespace function_detail {
 		}

 		template <bool is_yielding, bool no_trampoline>
-		static int call(lua_State* L) noexcept(std::is_nothrow_copy_assignable_v<T>) {
+		static int call(lua_State* L)
+ see https:github.comThePhDsol2issues1581#issuecomment-2103463524
+#if SOL_IS_ON(SOL_COMPILER_CLANG)
+		 apparent regression in clang 18 - llvmllvm-project#91362
+#else
+			noexcept(std::is_nothrow_copy_assignable_v<T>)
+#endif
+		{
 			int nr;
 			if constexpr (no_trampoline) {
 				nr = real_call(L);
@@ -19456,7 +19463,14 @@ namespace sol { namespace function_detail {
 		}

 		template <bool is_yielding, bool no_trampoline>
-		static int call(lua_State* L) noexcept(std::is_nothrow_copy_assignable_v<T>) {
+		static int call(lua_State* L)
+ see https:github.comThePhDsol2issues1581#issuecomment-2103463524
+#if SOL_IS_ON(SOL_COMPILER_CLANG)
+		 apparent regression in clang 18 - llvmllvm-project#91362
+#else
+			noexcept(std::is_nothrow_copy_assignable_v<T>)
+#endif
+		{
 			int nr;
 			if constexpr (no_trampoline) {
 				nr = real_call(L);
diff --git aincludeserverserver.hpp bincludeserverserver.hpp
index 34b8982e67..02b0dda050 100644
--- aincludeserverserver.hpp
+++ bincludeserverserver.hpp
@@ -53,8 +53,7 @@ class Server
         const auto port_string = std::to_string(port);
 
         boost::asio::ip::tcp::resolver resolver(io_context);
-        boost::asio::ip::tcp::resolver::query query(address, port_string);
-        boost::asio::ip::tcp::endpoint endpoint = *resolver.resolve(query);
+        boost::asio::ip::tcp::endpoint endpoint = *resolver.resolve(address, port_string).begin();
 
         acceptor.open(endpoint.protocol());
 #ifdef SO_REUSEPORT