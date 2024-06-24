class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https:github.comToruNiinatoml11"
  url "https:github.comToruNiinatoml11archiverefstagsv4.0.1.tar.gz"
  sha256 "96965cb00ca7757c611c169cd5a6fb15736eab1cd1c1a88aaa62ad9851d926aa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a3b9b48114ebe2d469b263a36b4656f17f875577c49f0786e4fb6d196f0e522"
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