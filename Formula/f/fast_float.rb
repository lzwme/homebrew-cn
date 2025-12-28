class FastFloat < Formula
  desc "Fast and exact implementation of the C++ from_chars functions for number types"
  homepage "https://github.com/fastfloat/fast_float"
  url "https://ghfast.top/https://github.com/fastfloat/fast_float/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "1c63903701c7aadbd47386752ab4efc3d324c9a2fbe230f461ff3806fa264d84"
  license "Apache-2.0"
  head "https://github.com/fastfloat/fast_float.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9bed2b501426afa83b2430899019398f9a7a65fbb3ef1dfd4918171667dae369"
  end

  depends_on "cmake" => :build

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