class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglearchiverefstagsv2024.09.09.00.tar.gz"
  sha256 "b0ffe343b622c3131f7ab6bcb89b7751c19f2da516372166f1a2591e2ff52f43"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b26b24ec1238e46b53194851bb8e6d4dc47ce0e67bcc57597f683ca5c92329f6"
    sha256 cellar: :any,                 arm64_sonoma:   "948972ebaa15cf4ff288ed23ee66580d7df991987935816fe4532912660fee10"
    sha256 cellar: :any,                 arm64_ventura:  "3281966d04e74bc9ae525824e4c7b86e893abe86f1fc50eb69449e2755b271ec"
    sha256 cellar: :any,                 arm64_monterey: "1b57000bec9e903e27e810c0f4ed33481b01f28bd400f9932b7eadd7e84d0de4"
    sha256 cellar: :any,                 sonoma:         "449666973aa61834ca8ff34128b66f3c9717659dc6b27c3c6c0bfb029e95bbd6"
    sha256 cellar: :any,                 ventura:        "f9fe29fabe95895101ec4ea2f4b23b3fb3af74ce1188bc03829baf1b94108f5f"
    sha256 cellar: :any,                 monterey:       "486ddce163ca6e71a6c8ec4729dabc788740af76bc820724dabf91050014a885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3658ac8cf501eb7263e5e818539cb55a221a56ea2ea74f43c806866b634096"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "bzip2"

  fails_with gcc: "5"

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    linker_flags = %w[-dead_strip_dylibs]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", "wangle", "-B", "buildshared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", "wangle", "-B", "buildstatic", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install "buildstaticliblibwangle.a"

    pkgshare.install Dir["wangleexampleecho*.cpp"]
  end

  test do
    # libsodium has no CMake file but fizz runs `find_dependency(Sodium)` so fetch a copy from mvfst
    resource "FindSodium.cmake" do
      url "https:raw.githubusercontent.comfacebookmvfstv2024.09.02.00cmakeFindSodium.cmake"
      sha256 "39710ab4525cf7538a66163232dd828af121672da820e1c4809ee704011f4224"
    end
    (testpath"cmake").install resource("FindSodium.cmake")

    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      find_package(gflags REQUIRED)
      find_package(folly CONFIG REQUIRED)
      find_package(fizz CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)

      add_executable(EchoClient #{pkgshare}EchoClient.cpp)
      target_link_libraries(EchoClient wangle::wangle)
      add_executable(EchoServer #{pkgshare}EchoServer.cpp)
      target_link_libraries(EchoServer wangle::wangle)
    EOS

    ENV.delete "CPATH"
    system "cmake", ".", "-DCMAKE_MODULE_PATH=#{testpath}cmake", "-Wno-dev"
    system "cmake", "--build", "."

    port = free_port
    fork { exec testpath"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end