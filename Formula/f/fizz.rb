class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghfast.top/https://github.com/facebookincubator/fizz/archive/refs/tags/v2025.12.29.00.tar.gz"
  sha256 "038c2808d7a8b3731d5ce49a770710e2100bd526c23d337736431859566d0ed4"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "ddff966f929a80d0f8ed92dc752196832301529eace64fd49d216e43293ed79b"
    sha256                               arm64_sequoia: "0f26521232cf3e373da88602c7f2ffa976ace307ff1c089bf402d57f878b71ea"
    sha256                               arm64_sonoma:  "2d5ac7c87221de3e400cb29eb9380e97ca38b0ec41465d2b9ae45e660b402e62"
    sha256 cellar: :any,                 sonoma:        "4d2bd12c300bf80d7c507d84079e01fb295220fbb06d9129a20fd9755f1e3e43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "addd63329f72d11575fe20acb5a119bb875e8c28d5352a3dc6d0152335a16a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab4dacae39c734ef6387fed86cbdd4da6905c2c4559bc2d3f3998b215cf21adb"
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