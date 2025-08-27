class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghfast.top/https://github.com/facebookincubator/fizz/releases/download/v2025.08.25.00/fizz-v2025.08.25.00.tar.gz"
  sha256 "25c0e6bdf629f70243dab2718dc3d4a55680f62284cd8599138ef0de1cee6701"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "98db8733f4c86e94a83523685290a564cb599eb34ee86a8043bce332455027b2"
    sha256                               arm64_sonoma:  "0a76bc149c31122e0f1dfcac97972fde2755ae9b3e19d0f274ae0b021695c77f"
    sha256                               arm64_ventura: "526df437c853f28d8914127a12daa9444b05f5efd0547edb9e3e55f0032761b1"
    sha256 cellar: :any,                 sonoma:        "d2b9cca15d0afa98db3ff07e7915d1a7d9e6788a7b04d5c53037c770efc12f0a"
    sha256 cellar: :any,                 ventura:       "51a5155b4eef3837c020fe9fbdced1b10b9c1697c9ebed6ee9985aa96a7580c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6af772f31bd2d7e8d1a55d197d2590145fb10760c9d5f47a0a6077b997aa9b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aab926b76772115724a3aeef51f4cf620d7393452b978c23d640b47f7b8adeb"
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