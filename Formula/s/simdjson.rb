class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "5b2506650aa6557612b9abfff3d60cfef2fb5ac06a3735c0c376d81af6432a14"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ffcd04b2d074616dd59e1b2c604e61a4010ee1184afc553dad91fc2a1ad7f2f6"
    sha256 cellar: :any,                 arm64_sequoia: "4d6f0504b13bb9506c381779bd7a9b085ba8db0cc99b0d2b79b2be66f1b78703"
    sha256 cellar: :any,                 arm64_sonoma:  "a823f52a3955fa61c958329b9ab1c7c24a66618cb2db0f08b2195d75c401f134"
    sha256 cellar: :any,                 sonoma:        "edbd3ad5624d3bed0ccfec47f80ef61cae4a89ea3cacba87c1a43123e96c07bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d23284aebc91a70787d7c3ea925c42c0462cabfd8b77be8c2a988d644f4247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea4b8ea191d2426b4a88917668e0ff70fef7236a36c2dd7b63b9b1694959a86"
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