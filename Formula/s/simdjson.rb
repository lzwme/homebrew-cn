class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "bf0d5fb1f6544153b50111fe644aa1f201e2d8fcf5109f17a9805dc6392974dd"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6daf4f695cf035bc5ba5b53916839d4e05bc0f3ac068532f39092d9b5fcc7eb"
    sha256 cellar: :any,                 arm64_sequoia: "99a41c3376b9ffddf372f5068c787644320fb01ec833167ab28c66fe84c49381"
    sha256 cellar: :any,                 arm64_sonoma:  "a33da68725355929df2cee4aed6e6b17f93712428ae9864346d01dd08ace4921"
    sha256 cellar: :any,                 sonoma:        "bcfa0411781d52a19a0a19ef1077a5235cb7d0016fa5f9a52a1f71c7380ecc20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de286369d0caa6fe7d7cd6d0a90b99c71ce88b42d482e9fd9e493b2ce9e6316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7462fc2fc7087bf37507c8c50a4198d2635497587909ca1fec972e7a5b79252"
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