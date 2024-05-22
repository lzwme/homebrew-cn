class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.0.4.tar.gz"
  sha256 "b439f89e879e538849e9106fe450bcf58da5034dfc316af4d2a837423786ed11"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "886f25c32241157925a4cd909850b737f6526ddddcc42f60b99595c0969ce004"
    sha256                               arm64_ventura:  "230af7d38dbcf88dd9590f32f4db856e24f69406b1f30155d8614debbd73b77e"
    sha256                               arm64_monterey: "3cd4ab992a260478891128f221b052943b2eb432600cb6f6eda134e43e9e291f"
    sha256                               sonoma:         "273b14395dbe23cb53e5896bc9d6acb397b5120c9d0b8b097d6f6c0d81fad883"
    sha256                               ventura:        "9df361bf336dca57c5dbdd9ff37ad20a931f68c32d916e8c49e76613618d7fe5"
    sha256                               monterey:       "1051cf695be79c0a7070b98e94a8a650702a1bd00c68b315f59cb825d7ee4314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b0ec1a9d74a18d8932dea0a8258c716a36f18437fdbd2920611db2946efac5"
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