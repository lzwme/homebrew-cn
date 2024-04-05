class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.0.1.tar.gz"
  sha256 "e8397511eec834eae157f267903449c07071f8c79be597cdf1e99e9b4fdd2347"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "8a2e1a712f8060ec910e6ddc1a5a59fa9b56a72a751a10882c2018589b22a4f9"
    sha256                               arm64_ventura:  "91257532221743340f16205177a3a8707ebfd004bfccacb2ff9f017624d41240"
    sha256                               arm64_monterey: "768da583716895e1bcaa7b1d49422ff53bbc6b7d93166f29e91eb98787bb4207"
    sha256                               sonoma:         "606df62b24c0c7982a2b7c6cc7eb4b2dc5486e4de520018c5c17dd75bb217028"
    sha256                               ventura:        "ee9b9f0ec25233327dada614f0f91590c13d8cdd625cb936c0a50dc38c2148a6"
    sha256                               monterey:       "18361fe6995f8c632316e6bcc5fad9268e5ecdbc1446ba48a87611b5844bdfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ed474c1f6c6671429eb0298ce214b27e8b8d5ac8319dff0770c988603b5a6ed"
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