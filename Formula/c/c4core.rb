class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://ghfast.top/https://github.com/biojppm/c4core/releases/download/v0.2.9/c4core-0.2.9-src.tgz"
  sha256 "cf4f0f0243e0dc3dd6d1ede9850c81240fdbf1d680649981e4255d7044ed4a3b"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f739be83b0d097c52cc8e5ee89684cf6ebb7550b5cfaf9891bdb5d739d4e488a"
    sha256 cellar: :any,                 arm64_sequoia: "a384858e159ea641f56675b5d1c62f9b53fdfc46627d87f7ca65ddfae5cee6ec"
    sha256 cellar: :any,                 arm64_sonoma:  "933ea60d9e04b390dcc3cbc53d3a334932ff6be17ba0fa3462a3f9a20a4c3c59"
    sha256 cellar: :any,                 sonoma:        "a3b31922f11301fa0e3d6237b6856db06a3127a9cdf9a6eb585888eb62dea919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03fbcb7b730678ea499bb86e73591c61f475095e222ca853f7c4a805a6fcd09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cefc57cc0f7da43f70cfa7267c7abf56f2bab6cb512af398030706044838c28c"
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