class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghfast.top/https://github.com/facebookincubator/fizz/releases/download/v2025.09.08.00/fizz-v2025.09.08.00.tar.gz"
  sha256 "670a995a4efab36ef0002c7ad95bfe5c8236c15e6f6eb1ae5e7320c0a8e510cb"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "3dfc00f14add4cc82ebc56e63702b063e6142799c95e302b46c0a5734926484e"
    sha256                               arm64_sequoia: "f9f46dae072952aa3a3b708b04162d691112fe13efc617f453abcf725a8f3dac"
    sha256                               arm64_sonoma:  "b052f2b4f8953dbdc65aeb2114670ad4ddc86e45180abc82dc6a95280da26de2"
    sha256                               arm64_ventura: "38857f638bd1895dae7c3a0bb67824da9fc076a6b0ca8e64a92e721374fbe943"
    sha256 cellar: :any,                 sonoma:        "ec3a0659f339d21542bdff6de34f0ff9772e63ce1f72468672c08e3da01fb8e3"
    sha256 cellar: :any,                 ventura:       "26115f21a22e7ccecfea69ead3a83c0ac72051a4f48fda9c5785ee80b397c189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773bb736e4678635d4198cb3eb47398a106c16f0870fd298855e06881bfee256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52794c3ab734f5055756e8e8f2e215c82fa1762f1eaa384f0c1743b315d12a3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libevent" => :build
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    args = ["-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      # Prevent indirect linkage with boost and snappy.
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end
    system "cmake", "-S", "fizz", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # `libsodium` does not install a CMake package configuration file. There
    # is a find module (at least in 1.0.20 tarball), but upstream has deleted
    # it in HEAD. Also, find modules are usually not shipped by upstream[^1].
    #
    # Since fizz-config.cmake requires FindSodium.cmake[^2], we save a copy in
    # libexec that can be used internally for testing `fizz` and dependents.
    #
    # [^1]: https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#find-module-packages
    # [^2]: https://github.com/facebookincubator/fizz/issues/141
    (libexec/"cmake").install "build/fbcode_builder/CMake/FindSodium.cmake"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(APPEND CMAKE_MODULE_PATH "#{libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(fizz CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fizz::fizz)
    CMAKE

    ENV.delete "CPATH"

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    assert_match "TLS", shell_output("./build/test")
  end
end