class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://ghfast.top/https://github.com/biojppm/c4core/releases/download/v0.3.0/c4core-0.3.0-src.tgz"
  sha256 "47a5634c785f84a6bef07c04c3cc3c063ff61c5c7554b95c35298712e2f306fd"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "daf4b936378ccef4c49ca3580556569e1d3fbb864d32ee5b898e0357d6896656"
    sha256 cellar: :any,                 arm64_sequoia: "89bae5b4f4575e1d80d30a133931cb764405191abb52abbb11d7de00b3a1df42"
    sha256 cellar: :any,                 arm64_sonoma:  "8368dbd011f108f58f1740839413e564dc99fed22c6dd30a26c464e8186fcb35"
    sha256 cellar: :any,                 sonoma:        "60f0bd983ac7706ca59a367655cd612bca99facac7505f4140c265a0f335d76e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dde5241446d5b7df18a6d9e04ce1b1858ae67f32eebece416b2dcf91f7400b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dbaff4f4a7bf0e53d8c1bdaf6181ed431b62286f80934f536b7492697a5faef"
  end

  depends_on "cmake" => [:build, :test]

  conflicts_with "rapidyaml", because: "both install `c4core` files `include/c4`"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(c4core_test)

      find_package(c4core)

      add_executable(c4core_test test.cpp)
      target_link_libraries(c4core_test c4core::c4core)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include "c4/charconv.hpp" // header file for character conversion utilities
      #include "c4/format.hpp"   // header file for formatting utilities
      #include <iostream>
      #include <string>

      int main() {
          // using c4core to do integer to string conversion
          int number = 42;
          char buf[64];
          c4::substr buf_sub(buf, sizeof(buf));
          size_t num_chars = c4::itoa(buf_sub, number);
          buf[num_chars] = '\0'; // Ensuring the buffer is null-terminated
          std::cout << "The number is: " << buf << std::endl;

          // For formatted output, first format into a buffer, then create a std::string from it
          char format_buf[64];
          snprintf(format_buf, sizeof(format_buf), "Formatted number: %d", number);
          std::string formatted_string = format_buf;
          std::cout << formatted_string << std::endl;

          return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal <<~EOS, shell_output("./build/c4core_test")
      The number is: 42
      Formatted number: 42
    EOS
  end
end