class FastFloat < Formula
  desc "Fast and exact implementation of the C++ from_chars functions for number types"
  homepage "https:github.comfastfloatfast_float"
  url "https:github.comfastfloatfast_floatarchiverefstagsv8.0.0.tar.gz"
  sha256 "8c017d31e9a324fdde4ff26c6c0206fc618addbd71491e76da0d7b038c4bf6d0"
  license "Apache-2.0"
  head "https:github.comfastfloatfast_float.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b90b036d596c0ddac53885003989ab00138c09f537796002a2a95a05fb9bbf2b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test-fast-float.cc").write <<~CPP
      #include "fast_floatfast_float.h"
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
    output = shell_output(".test-fast-float")

    assert_match "parsed the number", output
    refute_match "parsing failure", output
  end
end