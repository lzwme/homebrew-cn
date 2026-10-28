class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v5.0.6.tar.gz"
  sha256 "a2535137f8da93c0a61a6eeb47e96e502e16db89223b64f76b4041d595f797d7"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ca1017bff5768db3571737f3cb6a82ea5a5c84410b36f61ec14bcb64cddeaf31"
    sha256 cellar: :any, arm64_tahoe:       "715ffb108788b05ae26c714911aabc55c5ead005b95579922b27709d4615e43f"
    sha256 cellar: :any, arm64_sequoia:     "b592f033baa014ebb2f6ff5f9ccb933dbb18abb3d96ed63497e2c3999b4fb393"
    sha256 cellar: :any, arm64_linux:       "7bd36f5641dfa0e8a8ab7a7ea69fd126e49da6b0b2f2bc1661ee7cf148a95e1d"
    sha256 cellar: :any, x86_64_linux:      "ab1f516a3c8af3998411f148a97955428a6f80f3c117e4f14a10b0484de6ef8c"
  end

  depends_on "cmake" => :build

  deny_network_access!

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