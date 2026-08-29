class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.9.tar.gz"
  sha256 "b3954b7d6024eb5063c64e47be5ca09be04a3783563340400ce0aef416b20216"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbfac78d158ec3a8ed68c212dd93f29d73b6e6b72db448d9edfc4b241a76e766"
    sha256 cellar: :any, arm64_sequoia: "e09e5abf3bf8e30aa9a0a2ba36f403d5eb4e9071dbbc7caecb9d07498d8e0e57"
    sha256 cellar: :any, arm64_sonoma:  "b48ba21e0acaa0d7018f07fab4b421f542b6303ee957b7a6bea368c586cbf1cf"
    sha256 cellar: :any, arm64_linux:   "47103d061de82a09e716bdaaf6606fb8ab28cd6039b694d543c911c22475d889"
    sha256 cellar: :any, x86_64_linux:  "0ae85ef5874b741c39f3e8df5ae7aa324d6b53710179ba5bf7fcb13fef3146bc"
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