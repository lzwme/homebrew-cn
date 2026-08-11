class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://ghfast.top/https://github.com/abseil/abseil-cpp/archive/refs/tags/20260526.0.tar.gz"
  sha256 "6e1aee535473414164bf83e4ebc40240dec71a4701f8a642d906e95bea1aea0c"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "e037b5946416dd23cb3fc126328f431468acfe7a407da525cbe1e114edf703b6"
    sha256               arm64_sequoia: "0ce5d0400a357ff49f833e6b75625195f5367fc58343602baa322568ed4362a7"
    sha256               arm64_sonoma:  "fdc03654ce96baa1187ad84e8c1f9e319a9b43eb7c686d82eb5ead90cd24ab47"
    sha256 cellar: :any, sonoma:        "1f1b632e93523209f4ff64ee3eb1513a51473f5038f6c8b3c44fbb78b9f14bad"
    sha256 cellar: :any, arm64_linux:   "fddd7d705d0da31fd04461eea08326b4204295e82800eb0e5884b7fc92b68db5"
    sha256 cellar: :any, x86_64_linux:  "232f7c2c530777fbb16442f44f94c10383f5ae4421ed8a292d5426d6564ab88c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :build # For test helpers

  deny_network_access!

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