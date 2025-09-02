class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.09.01.00/proxygen-v2025.09.01.00.tar.gz"
  sha256 "f8602dfd40e4d2a72726c5f63cc430a6abac7e72fa005739be695b3d5d4fc31e"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "c6f97eab85d0a8c7c98fdb955f4608a749e12aab6aac6d95d37bcb55266c869e"
    sha256                               arm64_sonoma:  "4046d4e325229150a4b3bdc5a47f862b61e6433bd616d23fb0f56c6492d10547"
    sha256                               arm64_ventura: "0293c5d11f02ea35cdcf5459389c306bb62c445eb2692fd7d26739f365558475"
    sha256 cellar: :any,                 sonoma:        "eff39e7c46bd810b9978e0d43c879e20dedcc13a5560db4350f9e3cab67cbede"
    sha256 cellar: :any,                 ventura:       "2de9be28409b21a7e33d10bf239f7e7c98d47d76fa31701efa72c4df9918603e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d22132e208c9f4e7c220cc590702520ad99b3309b5c4a2ea84b4296e706a0a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e082af77c752ddb30c67107a49641f41125c4227baa2afcd7e77e7ea9f83846b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "c-ares"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # Fix name of `liblibhttperf2`.
  # https://github.com/facebook/proxygen/pull/574
  patch do
    url "https://github.com/facebook/proxygen/commit/415ed3320f3d110f1d8c6846ca0582a4db7d225a.patch?full_index=1"
    sha256 "4ea28c2f87732526afad0f2b2b66be330ad3d4fc18d0f20eb5e1242b557a6fcf"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/proxygen/pull/570
  patch :DATA

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    port = free_port
    pid = spawn(bin/"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end

__END__
diff --git i/CMakeLists.txt w/CMakeLists.txt
index cc189df..9d61345 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
@@ -80,17 +80,21 @@ find_package(ZLIB REQUIRED)
 find_package(OpenSSL REQUIRED)
 find_package(Threads)
 find_package(c-ares REQUIRED)
-find_package(Boost 1.58 REQUIRED
-  COMPONENTS
+set(PROXYGEN_BOOST_COMPONENTS
     iostreams
     context
     filesystem
     program_options
     regex
-    system
     thread
     chrono
 )
+find_package(Boost 1.58 REQUIRED COMPONENTS ${PROXYGEN_BOOST_COMPONENTS})
+if (Boost_MAJOR_VERSION EQUAL 1 AND Boost_MINOR_VERSION LESS 69)
+    list(APPEND PROXYGEN_BOOST_COMPONENTS system)
+    find_package(Boost 1.58 REQUIRED COMPONENTS ${PROXYGEN_BOOST_COMPONENTS})
+endif()
+string(REPLACE ";" " " PROXYGEN_BOOST_COMPONENTS "${PROXYGEN_BOOST_COMPONENTS}")
 
 list(APPEND
     _PROXYGEN_COMMON_COMPILE_OPTIONS
diff --git i/cmake/proxygen-config.cmake.in w/cmake/proxygen-config.cmake.in
index 8899242..114aaf7 100644
--- i/cmake/proxygen-config.cmake.in
+++ w/cmake/proxygen-config.cmake.in
@@ -31,16 +31,7 @@ find_dependency(Fizz)
 find_dependency(ZLIB)
 find_dependency(OpenSSL)
 find_dependency(Threads)
-find_dependency(Boost 1.58 REQUIRED
-  COMPONENTS
-    iostreams
-    context
-    filesystem
-    program_options
-    regex
-    system
-    thread
-)
+find_dependency(Boost 1.58 REQUIRED COMPONENTS @PROXYGEN_BOOST_COMPONENTS@)
 find_dependency(c-ares REQUIRED)
 
 if(NOT TARGET proxygen::proxygen)