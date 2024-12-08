class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https:simdjson.org"
  url "https:github.comsimdjsonsimdjsonarchiverefstagsv3.11.1.tar.gz"
  sha256 "18f7dfd267b90d177851623747598e45fbe4d91fc485f2b57ff0e3ae1b0fdde3"
  license "Apache-2.0"
  head "https:github.comsimdjsonsimdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6dbdf049d6df900b74448d89315a5eb162eb52ac11be6cd274099eb02ae063f"
    sha256 cellar: :any,                 arm64_sonoma:  "fa50d71be58b893917ec50ae210666c918384b06e95fabefb14a23173d4f17d5"
    sha256 cellar: :any,                 arm64_ventura: "581e5411e592dbb625a5a67da49d5335d02312c524cf3d5cac4fed747ea31198"
    sha256 cellar: :any,                 sonoma:        "e9bc487850bc8d5b0ab187aa43dc21358348f7c63d8557fba8a98c12b48d4b4e"
    sha256 cellar: :any,                 ventura:       "c19e260436e806fed6960bbf30bbf13d1e445507043e4a8ac8b9003feecfc8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffbd9ee87f39e981e6a593829d96de601072920b3a79883640060df583871f7d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "buildlibsimdjson.a"
  end

  test do
    (testpath"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath"test.cpp").write <<~CPP
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
    assert_equal "\"Homebrew\"\n", shell_output(".test")
  end
end