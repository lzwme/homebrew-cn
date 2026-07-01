class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghfast.top/https://github.com/facebookincubator/fizz/archive/refs/tags/v2026.06.29.00.tar.gz"
  sha256 "d495380989191b6ff8151b439fe3f74df55e93f0e458607c9b344e6051f3032a"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9f4fb9c02de9f51d6ed4b3038816496d22c81836542a111e293520cf2c1e9abe"
    sha256 cellar: :any, arm64_sequoia: "101b926e63eb28ccee97958d311e0e07a1ad398599ec603749aff7d123677d08"
    sha256 cellar: :any, arm64_sonoma:  "e924d98d83efcff3944b0d06a5d227b1750ecb5d3a6bf020d046e88be82a8f93"
    sha256 cellar: :any, sonoma:        "40253b1f0dd25eb89b1831a6c6b8017c33823806afb9a22a32ab5050c007c6ac"
    sha256 cellar: :any, arm64_linux:   "a9262ea783eefb29b9def4936d688d1d23c24caff7769361daed1187f9b72dc8"
    sha256 cellar: :any, x86_64_linux:  "450e3247a8836528c4ae379bcd3f2c6a7357624b7e9226e70910a16ab0e06024"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gflags" => :build
  depends_on "libevent" => :build
  depends_on "fmt"
  depends_on "folly"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    if OS.mac?
      # Prevent indirect linkage with boost and snappy.
      args += %w[
        -DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs
        -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs
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
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 20)

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