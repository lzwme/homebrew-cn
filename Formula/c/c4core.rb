class C4core < Formula
  desc "C++ utilities"
  homepage "https:github.combiojppmc4core"
  url "https:github.combiojppmc4corereleasesdownloadv0.2.3c4core-0.2.3-src.tgz"
  sha256 "a28016b07c065aa5af64b502fc0e455c6b7dcc1498066a7d40c4d0b3320911fe"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3665584010bd8c8f89b137e9d0be8dc2e8d983105367d844623f6c2b479b6580"
    sha256 cellar: :any,                 arm64_sonoma:  "30307533e0fafa77073c57011b2c5ebeacd1faf56e9dadbef7f4ca25721dd09a"
    sha256 cellar: :any,                 arm64_ventura: "b889189b4689b806121e9cf742a0b164025b3f6c5b450dafb6588bd16859202f"
    sha256 cellar: :any,                 sonoma:        "c9e06ff2f9bf9c95d193a5d79fa8f45ce81177aaa0d39d3a0960827fd9696ac0"
    sha256 cellar: :any,                 ventura:       "597efaa4a4ec2466963f8cb772fabe0420c8cc520f2675a6c98ec516b249b8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d039a2bf18a036b1bcc6e686eee0f0a7d664f262ac68c0d26d3e1f596dc069c4"
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