class C4core < Formula
  desc "C++ utilities"
  homepage "https:github.combiojppmc4core"
  url "https:github.combiojppmc4corereleasesdownloadv0.2.4c4core-0.2.4-src.tgz"
  sha256 "7f258990a1c62a734b39246a79dbb20d0b99cfb12c1d75739b4f142e81703dce"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d68a3124bb9f730ca8501c812ff162ae7b5ad2203addeaa7b4b66854dd13b86c"
    sha256 cellar: :any,                 arm64_sonoma:  "d277fb0f4552fcd3d699049bfdc7f1e6bf5cf361c280ec83f738349b0fec8a5c"
    sha256 cellar: :any,                 arm64_ventura: "16f956aa7a00ba7df107781e206ddf57d85560d3603a76569d2faa54282dac61"
    sha256 cellar: :any,                 sonoma:        "bc2fbc726e40c95056d1b81cb96298a5267d35805913c84c3f4b4edb8aeb8aed"
    sha256 cellar: :any,                 ventura:       "b244d29f28e57255a079d784572b64fb68882ca3c0876af7e39527328251507d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3814841f468554c1f2355143a7fe83475e9bf012ea82ed8a37181a8f64e8d5e"
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