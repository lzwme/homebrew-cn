class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.5.tar.gz"
  sha256 "01b741033d4ce460226f43176ffcc140133e4c251e6c22284fce5b27a824b2f2"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "426be98c9842e55bc66913a1accabd8121fec0169fa10ba69df3db7b091e6ad8"
    sha256 cellar: :any, arm64_sequoia: "fce06180c54d37042a84fdcf62515c11681bae5261d63ca32bc4b234bde21214"
    sha256 cellar: :any, arm64_sonoma:  "87719995d238b2020c8c34cf84ddec829e3803a03cde1ab73cbc6e9f9490f4d9"
    sha256 cellar: :any, sonoma:        "fccd85a6150bc0c49edaea75c38f232184be1161b5f62e312177724695826ace"
    sha256 cellar: :any, arm64_linux:   "94f947f6a6873abaec5ba2ad8b33378959583588403f63b42d0e3098bd5b2065"
    sha256 cellar: :any, x86_64_linux:  "0764b17a447fcd26bcef9f13bf65d9d1c42acbc3ca441b699d9247766d93826c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSIMDJSON_BUILD_STATIC_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.json").write({ name: "Homebrew", isNull: nil }.to_json)
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end