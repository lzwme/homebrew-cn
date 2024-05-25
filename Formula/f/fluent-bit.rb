class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.0.5.tar.gz"
  sha256 "d7cb180ecacf31a85c71932f4210876d6d41b4e250ceeb85650e2133a1dfd0f7"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "48e87454b13008ee3c9a7d64f5886e3b01fd5b47dcca882f501a0186c52807b4"
    sha256                               arm64_ventura:  "6ede1272126990fe23d4d9fdfe62206b31d66ae87a6a85f7d386bbd3ddf154c6"
    sha256                               arm64_monterey: "dd2aba738955a4379f97f47b73673efa3813628b39ea6490c390291d8a69ec8b"
    sha256                               sonoma:         "1ad9e22d4e652f0fa249341c9ba33d1ca5b8e75aefd306dccc0be591245099b5"
    sha256                               ventura:        "65ec59b02d490a39c1b1ad57c7f6d5c83ed6ff68f6ce3bb54b54c99c1a8939a7"
    sha256                               monterey:       "a07e2fd9743827c30580d8ab06411286b175d3f55f1d3f79bc204db13ded4629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93ad6588847b231ff36948affda4dc0ff8addc5ab105f48386198d8a834193e3"
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