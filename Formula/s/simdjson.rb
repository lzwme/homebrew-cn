class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.6.tar.gz"
  sha256 "1cd4c4c18263d2ae1f0cd5d4ba8b14e679b5a419ca15988a0da4cf43c514f28d"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "da88957275c7f0fd3f47f6e183da15eda1c4fd013515c59d8a75316fbf8ddeff"
    sha256 cellar: :any, arm64_sequoia: "a824a28ffc068be855d204b0b76fc096453013a76e84ccfc200acf3289197095"
    sha256 cellar: :any, arm64_sonoma:  "fbcc9770935169912c730f01f08a7c9dc0a4da24d656a720c48ce2d0a0b2d22b"
    sha256 cellar: :any, sonoma:        "45b0205563f2f25031d2bf919e1f8030d49aa10f30668c128f80c7a298ccb839"
    sha256 cellar: :any, arm64_linux:   "8e04224c9afeef7133e492fd1c4c45e032ec0392a2ad40a175317a71aaff115b"
    sha256 cellar: :any, x86_64_linux:  "4ae6ad35a77df021c89c62d6bb82fb2b3b9b962143761a9a840d8492b69cbb2a"
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