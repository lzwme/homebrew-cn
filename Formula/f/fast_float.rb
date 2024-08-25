class FastFloat < Formula
  desc "Fast and exact implementation of the C++ from_chars functions for number types"
  homepage "https:github.comfastfloatfast_float"
  url "https:github.comfastfloatfast_floatarchiverefstagsv6.1.4.tar.gz"
  sha256 "12cb6d250824160ca16bcb9d51f0ca7693d0d10cb444f34f1093bc02acfce704"
  license "Apache-2.0"
  head "https:github.comfastfloatfast_float.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "11e47dcfe78bd0703495c9f86b1feb600d24e6ddb26e0573c099c9a9bb22cb9f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test-fast-float.cc").write <<~CXX
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
    CXX

    ENV.append_to_cflags "-I#{include}"
    ENV.append "CXXFLAGS", "-std=c++11"

    system "make", "test-fast-float"
    output = shell_output(".test-fast-float")

    assert_match "parsed the number", output
    refute_match "parsing failure", output
  end
end