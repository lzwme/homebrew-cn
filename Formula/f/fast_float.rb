class FastFloat < Formula
  desc "Fast and exact implementation of the C++ from_chars functions for number types"
  homepage "https://fastfloat.github.io/fast_float/"
  url "https://ghfast.top/https://github.com/fastfloat/fast_float/archive/refs/tags/v8.3.1.tar.gz"
  sha256 "7ff47ad261068517561beb0a7c1d57131f71b8be19bdbac2857c6a517a2eb53c"
  license "Apache-2.0"
  head "https://github.com/fastfloat/fast_float.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55bbc7f4cce481a68b9a7a0c46c1fccfad5bac01c784d611d3a4575d3f886557"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test-fast-float.cc").write <<~CPP
      #include "fast_float/fast_float.h"
      #include <iostream>

      int main() {
          const std::string input =  "3.1416 xyz ";
          double result;
          auto answer = fast_float::from_chars(input.data(), input.data()+input.size(), result);
          if(answer.ec != std::errc()) { std::cerr << "parsing failure\\n"; return EXIT_FAILURE; }
          std::cout << "parsed the number " << result << std::endl;
          return EXIT_SUCCESS;
      }
    CPP

    ENV.append_to_cflags "-I#{include}"
    ENV.append "CXXFLAGS", "-std=c++11"

    system "make", "test-fast-float"
    output = shell_output("./test-fast-float")

    assert_match "parsed the number", output
    refute_match "parsing failure", output
  end
end