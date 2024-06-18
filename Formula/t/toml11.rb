class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https:github.comToruNiinatoml11"
  url "https:github.comToruNiinatoml11archiverefstagsv4.0.0.tar.gz"
  sha256 "f3dc3095f22e38745a5d448ac629f69b7ee76d2b3e6d653e4ce021deb7f7266e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9181ed03c86fcfbad4e180a7f4b67731efb384f52371a44acf1c823f272ee321"
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