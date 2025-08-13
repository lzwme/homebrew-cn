class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghfast.top/https://github.com/facebookincubator/fizz/releases/download/v2025.08.11.00/fizz-v2025.08.11.00.tar.gz"
  sha256 "4b488cb4e3cff707081c286ae96bfa93250c8f53ab1a4e8b56cc55943f7c782b"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "587f5b45b40fb979a94eb7e41fe18734176333ddcf372f3a48f8a07fe1867897"
    sha256                               arm64_sonoma:  "80c8cc4d78ba2d6f45923a809ea1269e66a3f37b6e6519aa0cde86939a2d50c2"
    sha256                               arm64_ventura: "071a3895a66cab6110a95e959dffe6ae3b1bf10617c4db03e478a2cc39f69262"
    sha256 cellar: :any,                 sonoma:        "1240433032929a0a0e08d2b7d869850500acc916d498763809a1a9413ff15be8"
    sha256 cellar: :any,                 ventura:       "a6e7c80fa22c811b713e555319d4bad5950edfc1e94e664e6761c8e94369e264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e260629b24a64009cbe94636c7268ef2bb4be48a6b18f70ead7c0141e1bf8d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963c73e6d3b79fa3ab65ecc8896839b480b8d3b927f5572fbe8e9b6f0df8b8b1"
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