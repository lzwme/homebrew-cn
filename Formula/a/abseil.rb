class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://ghfast.top/https://github.com/abseil/abseil-cpp/archive/refs/tags/20250512.1.tar.gz"
  sha256 "9b7a064305e9fd94d124ffa6cc358592eb42b5da588fb4e07d09254aa40086db"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "1c7ca4a20ec65668ac2ddfbc185a2143af494ee5601fdfd33a919ee60491194d"
    sha256                               arm64_sonoma:  "1f151d2bc25baeac2a6097df5b16782a223cd58314035bd2d2310e84b451f09f"
    sha256                               arm64_ventura: "37f0fc524f8326447cccfcd1f4cffce211b0558dcec74e9899591a112d7e2416"
    sha256 cellar: :any,                 sonoma:        "0f31cf70421f1929fd31770f98fbe8b8e583297a1fc4865d6b855c8e8d75310f"
    sha256 cellar: :any,                 ventura:       "c9f0990f410cb351c2e99bb60206755450fd4cff14518ee65f122251dc8fbca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab53a04e9d6b7624796a1f1b468de5fe710aa344218e34c80826c7f50b76c5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f021330afe0a015ed806a50aef84524a4d6c17af6869640b61667c435f3b0ffd"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :build # For test helpers

  def install
    ENV.runtime_cpu_detection

    # Install test helpers.
    extra_cmake_args = %w[ABSL_BUILD_TEST_HELPERS ABSL_USE_EXTERNAL_GOOGLETEST ABSL_FIND_GOOGLETEST].map do |arg|
      "-D#{arg}=ON"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DABSL_PROPAGATE_CXX_STD=ON",
                    "-DABSL_ENABLE_INSTALL=ON",
                    *extra_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello_world.cc").write <<~CPP
      #include <iostream>
      #include <string>
      #include <vector>
      #include "absl/strings/str_join.h"

      int main() {
        std::vector<std::string> v = {"foo","bar","baz"};
        std::string s = absl::StrJoin(v, "-");

        std::cout << "Joined string: " << s << "\\n";
      }
    CPP
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)

      project(my_project)

      # Abseil requires C++14
      set(CMAKE_CXX_STANDARD 14)

      find_package(absl REQUIRED)

      add_executable(hello_world hello_world.cc)

      # Declare dependency on the absl::strings library
      target_link_libraries(hello_world absl::strings)
    CMAKE
    system "cmake", testpath
    system "cmake", "--build", testpath, "--target", "hello_world"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/hello_world")
  end
end