class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https:github.commaxbachmannrapidfuzz-cpp"
  url "https:github.commaxbachmannrapidfuzz-cpparchiverefstagsv3.0.1.tar.gz"
  sha256 "67ec2e3414e3f98ccf9244b0daef9d76d4fd844b5212f7ad22c23625bc12ae30"
  license "MIT"
  head "https:github.commaxbachmannrapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07f3dfa191106248c43d1faf881751e64c339e46af3503bba8bb1cd3485516fc"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <rapidfuzzfuzz.hpp>
      #include <string>
      #include <iostream>

      int main()
      {
          std::string a = "aaaa";
          std::string b = "abab";
          std::cout << rapidfuzz::fuzz::ratio(a, b) << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-o", "test"
    assert_equal "50", shell_output(".test").strip
  end
end