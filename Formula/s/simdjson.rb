class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v5.0.7.tar.gz"
  sha256 "a5282c9b00f6c8b5217f434636c78ee7c9019f2fd2aa478ba850d2e2584c0994"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "05b1e82418cba951d7206f5857929b868b87498d7218482b20adfab39883adea"
    sha256 cellar: :any, arm64_tahoe:       "af1fd7923ce0e0e687fb829c80ee551e21f659286f3eb6d63256198a328d341a"
    sha256 cellar: :any, arm64_sequoia:     "11f5e2bbec44c51042ca569bc6303c5a8acc8e9d0028771cdbec24e751de41ec"
    sha256 cellar: :any, arm64_linux:       "0eaefbac9e28517cba13161b45f7a7a40955f442b13d354e5312c5325928dd0d"
    sha256 cellar: :any, x86_64_linux:      "75dd4288b4c34d2a453312d297b965102e82fc99f2e1e4c4bb15837ca6cc1aca"
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