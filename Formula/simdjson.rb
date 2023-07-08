class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghproxy.com/https://github.com/simdjson/simdjson/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "121206c9bfe972a2202a74d4cddb8cb0561932427f96d6c4b70fb49a2a74560e"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f35bdd3dace95899ac335632b630240fe5e22849d5aad32dbc9f6ecf2914c828"
    sha256 cellar: :any,                 arm64_monterey: "c9cd0df3d7c87cb099da20ce577b591b54955d86dcba4ac266a0a71978647926"
    sha256 cellar: :any,                 arm64_big_sur:  "cc86de0ac9f84c8ab5cd2222594af58540b89e5b44aad8cf30d45ec5f2b80408"
    sha256 cellar: :any,                 ventura:        "b2cb4e0f5ce9f55c8c8ffae9566779d998da2516ab0289fdc41fba2182b7357c"
    sha256 cellar: :any,                 monterey:       "a777711d3f0c8314ee5ec5d17a74c4f26137fd4891aa2e1c72f916969e9e13b0"
    sha256 cellar: :any,                 big_sur:        "30cf1063404bc53f7fe6af1255d9a25c7e935b1459228532a7af8e780bf7898f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a16a9bafdbdedc0b4eb7cb8b3994c21ee587eaf37bf92261abb1e8349fa3e6c5"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end