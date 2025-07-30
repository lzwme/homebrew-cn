class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghfast.top/https://github.com/facebookincubator/fizz/releases/download/v2025.07.28.00/fizz-v2025.07.28.00.tar.gz"
  sha256 "cd24aafcd2695555f058e82c7e4dd466e1f2fafecefea885518a8dc59109a5b0"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "292da69ad41b4afc967dc859d98959dc9c43cacf105e2f2c175069376997f9ae"
    sha256                               arm64_sonoma:  "cfba21ab1d764f16c9bfd01b081e4b2ad3bd1cb261ece807f8d15264d2c34adf"
    sha256                               arm64_ventura: "e908f8350287387f8de3277d0d5a67d1172b566154ed2cf63af139e5aab95f2a"
    sha256 cellar: :any,                 sonoma:        "b1c2cc8710ef56e742fc28d6925b7a60f8896285e3dbc0c062ea378f4746fc8c"
    sha256 cellar: :any,                 ventura:       "861c21725d04e55248b34022c9458db5ce04e6be1da3c843a75505ce8210b153"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de291cbfafc2e4496d0eaa303a02cc09417ca730f41244eff9cdb0b5321230d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d6fa9042802fbe1e9596be1cab3e0455a404f1fea03cccd61171653bcc1b7b"
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