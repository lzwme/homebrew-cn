class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.0.6.tar.gz"
  sha256 "2cad0ac1e04646bc084b7bb3d5552589fa1997eaa5ba3fe2137a65ecf101cd9f"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "2f27477074f13c0846cdef058cf8542dde3cd5f9f8074d8f5673839e3bd15fc4"
    sha256                               arm64_ventura:  "8da7ab548825c87ed0f9ff781741000a860cd51fd81a5548c3eeba42ea7c811c"
    sha256                               arm64_monterey: "b989811413ceeb3a1a0ba1ec7751ee835a4410fd606e84ab8111f31ac20f475b"
    sha256                               sonoma:         "f1042dbc7b5d60997a46824a776d0a4874c07fa5749a98540f6ef4f7ac788afb"
    sha256                               ventura:        "dda9e8fc48d166313937c1e7e67b29b97d1d10c7d6b5d0d38bd7315af7f99301"
    sha256                               monterey:       "ba29185c8dcf46864fd2fd7955a2be268337f2539f73b0bb448690c31fb22bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9e46ee40d455fbfe2bffa54de2dc150e42f7c07f24c771935677c71dd1db142"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  # Avoid conflicts with our `luajit` formula.
  # We don't need to set LDFLAGS because LuaJIT is statically linked.
  patch :DATA

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https:github.comfluentfluent-bitissues3393
    inreplace "srcCMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY libsystemdsystem)", "if(False)"
    inreplace "srcCMakeLists.txt", "elseif(IS_DIRECTORY usrshareupstart)", "elif(False)"

    # Per https:luajit.orginstall.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end

__END__
--- alibluajit-cmakeLuaJIT.cmake
+++ blibluajit-cmakeLuaJIT.cmake
@@ -569,13 +569,13 @@ set(luajit_headers
   ${LJ_DIR}luaconf.h
   ${LJ_DIR}luajit.h
   ${LJ_DIR}lualib.h)
-install(FILES ${luajit_headers} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}luajit)
+install(FILES ${luajit_headers} DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}includeluajit)
 install(TARGETS libluajit
-    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
-    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
+    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}lib
+    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}lib)

 # Build the luajit binary
-if (LUAJIT_BUILD_EXE)
+if (FALSE)
   add_executable(luajit ${LJ_DIR}luajit.c)
   target_link_libraries(luajit libluajit)
   if(APPLE AND ${CMAKE_C_COMPILER_ID} STREQUAL "zig")