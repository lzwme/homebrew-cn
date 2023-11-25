class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https://github.com/maxbachmann/rapidfuzz-cpp"
  url "https://ghproxy.com/https://github.com/maxbachmann/rapidfuzz-cpp/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "df4412e9593945782de2212095bd4b70a8f8e63ae8f313976c616809be124d2c"
  license "MIT"
  head "https://github.com/maxbachmann/rapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fb7986a22adf9705d5b862c448aa000f7d489bbca6302a4f33e9e4d175689be"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rapidfuzz/fuzz.hpp>
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
    assert_equal "50", shell_output("./test").strip
  end
end