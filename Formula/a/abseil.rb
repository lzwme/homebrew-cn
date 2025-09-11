class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://ghfast.top/https://github.com/abseil/abseil-cpp/archive/refs/tags/20250814.0.tar.gz"
  sha256 "9b2b72d4e8367c0b843fa2bcfa2b08debbe3cee34f7aaa27de55a6cbb3e843db"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "56b3a21b45345bac3b6e7c8574c1fcadd8dbee2632006f3935c32154dd08c4c4"
    sha256                               arm64_sequoia: "46c63da34f7ff761501842d4068f9bfaabbadf12568424c87491b19065d3b17f"
    sha256                               arm64_sonoma:  "19df247e567459110a43ff1bd216af37d626e8ee2d2ad69e74d8c34e765f0dad"
    sha256                               arm64_ventura: "f59c0c62a921b35d5690c72b2440a532e927ad4f46825d9e3834db13af5794b1"
    sha256 cellar: :any,                 sonoma:        "f62bab7dc820937f2086e0b9a5d9635f5d0348ea810e24b2f4a5747ed0e7979a"
    sha256 cellar: :any,                 ventura:       "c011eeeccd1dfb6c2804163ef4619304e5821be64651d44b71c7112794ee9f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef3e9a33b4ab2fc9659dae39ad3d71dda4e7e3fc29dd84a379ff4d19b9556a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d58b90b49e1a35f2a67eb462aea9ad2a5be1c463e86808d9a1df6e7e504bb98"
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