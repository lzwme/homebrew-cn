class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https:github.comToruNiinatoml11"
  url "https:github.comToruNiinatoml11archiverefstagsv4.0.2.tar.gz"
  sha256 "d1bec1970d562d328065f2667b23f9745a271bf3900ca78e92b71a324b126070"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e893c6b4c7584f148e457f939cc5fdade1c8aa2f1af773da99e18542b6144c96"
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