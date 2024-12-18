class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https:github.comrapidfuzzrapidfuzz-cpp"
  url "https:github.comrapidfuzzrapidfuzz-cpparchiverefstagsv3.2.0.tar.gz"
  sha256 "45504e1091814017fb16e69b9f9494233043eee6a8a17ee7c327ffde3b0cc412"
  license "MIT"
  head "https:github.comrapidfuzzrapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "277d9dee97404183fd28fb6be9dabb88341d26e6b9ca824c79b28065da8758da"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <rapidfuzzfuzz.hpp>
      #include <string>
      #include <iostream>

      int main()
      {
          std::string a = "aaaa";
          std::string b = "abab";
          std::cout << rapidfuzz::fuzz::ratio(a, b) << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-o", "test"
    assert_equal "50", shell_output(".test").strip
  end
end