class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghproxy.com/https://github.com/simdjson/simdjson/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "6932172c1066b64d123f9db8a5183fa11e07f3e9fb87c39101683dca08fd884a"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5cef86cad501d9d8ca023bd61ba75d9221621c152c03f36bec37300cdd2d84f5"
    sha256 cellar: :any,                 arm64_ventura:  "748f190c9b7428c2a80a5a46eb13489317bad6cef065bd46f8d2ab32af433e30"
    sha256 cellar: :any,                 arm64_monterey: "2d8f7391ed32cb898ff05f21683197ccb8fcb0296bbb3bab15e26e62d749112f"
    sha256 cellar: :any,                 sonoma:         "33fc1cbba9a55794e344a2b8fd6da5f4ce18f945731d4323caa29f7ecdce6b36"
    sha256 cellar: :any,                 ventura:        "85460ecaf3893cee73c6ca6096b84b91bf5d5b2e260140a11d9764517dc674eb"
    sha256 cellar: :any,                 monterey:       "687c38d1faba7864b589deda1413922e4ca265de4e9e9bbe978e7cf4e193b766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a46915a0dfe9c3ca12cc14199998a605bdfbb1ee24f6a6b12e4c4ca89a0e90"
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