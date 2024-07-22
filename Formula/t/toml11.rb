class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https:github.comToruNiinatoml11"
  url "https:github.comToruNiinatoml11archiverefstagsv4.1.0.tar.gz"
  sha256 "fb4c02cc708ae28e6fc3496514e3625e4b6738ed4ce40897710ca4d7a29de4f7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fb1a5de8029eaa43764e3ff33cf4841341cf362427de70a99a7bb85fe3bbc2c"
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