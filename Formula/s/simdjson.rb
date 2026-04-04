class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "f019e8f4c7d1d59dff6eb4bd69266f54ed60ffd7831bec0708ae7746d05f8ae0"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f902841dafb8cb6b8061a5472fd85305a0d9ac2266062061f48e63b4bc7bfa9"
    sha256 cellar: :any,                 arm64_sequoia: "b18f364cdf74058d48c18cbcd5b46281a020ccc28d05bec5f1910b2e27a0e212"
    sha256 cellar: :any,                 arm64_sonoma:  "132fd1b85d39f6c6c9f25babc58e3259634effb829278c01a1b2c5762b669575"
    sha256 cellar: :any,                 sonoma:        "c5c055fc7f47f35ca84cd4787e32f87132eddb7138ed1f0522845b98d59536ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50afe5278133705c7dc557bd76d16f2ab745f0da55ec25397d2f3a1559c2a475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c48727f4434bd5a90c6cf36f488d3b122cb6e34e37c708afd4edd632bb51ee9"
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