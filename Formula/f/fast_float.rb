class FastFloat < Formula
  desc "Fast and exact implementation of the C++ from_chars functions for number types"
  homepage "https:github.comfastfloatfast_float"
  url "https:github.comfastfloatfast_floatarchiverefstagsv6.1.5.tar.gz"
  sha256 "597126ff5edc3ee59d502c210ded229401a30dafecb96a513135e9719fcad55f"
  license "Apache-2.0"
  head "https:github.comfastfloatfast_float.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d591c6a5d42db64fa7f059d4284c56b03a6f951b926171a59c783af503925c5"
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