class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https:github.comrapidfuzzrapidfuzz-cpp"
  url "https:github.comrapidfuzzrapidfuzz-cpparchiverefstagsv3.1.1.tar.gz"
  sha256 "5a72811a9f5a890c69cb479551c19517426fb793a10780f136eb482c426ec3c8"
  license "MIT"
  head "https:github.comrapidfuzzrapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e62b67041ceb7e94f6ca3b761995d20f2d5d686ba951ad47e8fda3a86c969df"
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