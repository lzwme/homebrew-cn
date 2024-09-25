class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglearchiverefstagsv2024.09.23.00.tar.gz"
  sha256 "0c679f59456729ee23acb99328e17c750ee4b74b29458198c99387d9cc34c04a"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0997c08e8ea979b52641e249e8ec2c07125ee478dbdc27346a04bc774bfbd24"
    sha256 cellar: :any,                 arm64_sonoma:  "28d6bac69ebe06a86b893eee14b8581d80a1eb024092275a5281bd3c04cf178d"
    sha256 cellar: :any,                 arm64_ventura: "61beddb1b87a4578e4c406de3aa895c3e7e282a0858eb1e093b2eeb499f4ea12"
    sha256 cellar: :any,                 sonoma:        "8545ea8d081932e5f350539815a1153551e02b266ce471d53e326f7d044105ca"
    sha256 cellar: :any,                 ventura:       "2afcd2f1a1aaf1d2f6985c1617729e7f4820f1c03ccc81bf3f219bd514cb6a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8bb1aaf04566deb902a6e5defbfbc6b8c222696988d1df28cbfefcd8a7e236f"
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