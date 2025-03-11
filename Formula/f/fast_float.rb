class FastFloat < Formula
  desc "Fast and exact implementation of the C++ from_chars functions for number types"
  homepage "https:github.comfastfloatfast_float"
  url "https:github.comfastfloatfast_floatarchiverefstagsv8.0.1.tar.gz"
  sha256 "18f868f0117b359351f2886be669ce9cda9ea281e6bf0bcc020226c981cc3280"
  license "Apache-2.0"
  head "https:github.comfastfloatfast_float.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd8e1d486cf9a2acd60e9bdc3d0d3924e1ad92fa91048cf3ee39961ca3dbcc5e"
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