class C4core < Formula
  desc "C++ utilities"
  homepage "https:github.combiojppmc4core"
  url "https:github.combiojppmc4corereleasesdownloadv0.2.5c4core-0.2.5-src.tgz"
  sha256 "758f23718cbdc9465f104249561c4028858caf3355a90616b54d1dd937a981b1"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "db1b389a792b0c706e60ca3dc45a91038721ecd3f0b6bfc9a8997cf8564f0c2e"
    sha256 cellar: :any,                 arm64_sonoma:  "3d406c980d9a46189724a5413f3047a0dd78ea3d254ecbad9ec366bde3cc67e8"
    sha256 cellar: :any,                 arm64_ventura: "da3f3b490903b89c121305fd112b372e2cff4cf32eae6d1e44c9fb64f10bbe8d"
    sha256 cellar: :any,                 sonoma:        "cfe600abd4d4d911e2416c8b07d51693db2432238e79d3efcd278b1b02c22028"
    sha256 cellar: :any,                 ventura:       "8c5b12b46d37916e0b5e5f11bc4b00260467a905ac490858c2d172410d0ac6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "069cce0a054094573cdd0338332b80640a38fa412d4d4c0cf3b653297a24ebb9"
  end

  depends_on "cmake" => [:build, :test]

  conflicts_with "rapidyaml", because: "both install `c4core` files `includec4`"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(c4core_test)

      find_package(c4core)

      add_executable(c4core_test test.cpp)
      target_link_libraries(c4core_test c4core::c4core)
    CMAKE

    (testpath"test.cpp").write <<~CPP
      #include "c4charconv.hpp"  header file for character conversion utilities
      #include "c4format.hpp"    header file for formatting utilities
      #include <iostream>
      #include <string>

      int main() {
           using c4core to do integer to string conversion
          int number = 42;
          char buf[64];
          c4::substr buf_sub(buf, sizeof(buf));
          size_t num_chars = c4::itoa(buf_sub, number);
          buf[num_chars] = '\0';  Ensuring the buffer is null-terminated
          std::cout << "The number is: " << buf << std::endl;

           For formatted output, first format into a buffer, then create a std::string from it
          char format_buf[64];
          snprintf(format_buf, sizeof(format_buf), "Formatted number: %d", number);
          std::string formatted_string = format_buf;
          std::cout << formatted_string << std::endl;

          return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal <<~EOS, shell_output(".buildc4core_test")
      The number is: 42
      Formatted number: 42
    EOS
  end
end