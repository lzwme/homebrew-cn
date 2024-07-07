class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https:github.comToruNiinatoml11"
  url "https:github.comToruNiinatoml11archiverefstagsv4.0.3.tar.gz"
  sha256 "c8cbc7839cb3f235153045ce550e559f55a04554dfcab8743ba8a1e8ef6a54bf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7243b83a9a49f42b06ace15c554d5fa1f9e260089f3363aa964f4bc088bb616f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=11",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.toml").write <<~EOS
      test_str = "a test string"
    EOS

    (testpath"test.cpp").write <<~EOS
      #include "toml.hpp"
      #include <iostream>

      int main(int argc, char** argv) {
          const auto data = toml::parse("test.toml");
          const auto test_str = toml::find<std::string>(data, "test_str");
          std::cout << "test_str = " << test_str << std::endl;
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "test_str = a test string\n", shell_output(".test")
  end
end