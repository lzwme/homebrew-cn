class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "c240d4bffcccda4fe3a2bba2872718d96fc92e56d2615bfac4f9b2bad89a6386"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb8d30c88d910f690e399c35fe10779215440a8e5ae0ba7f633a2b7980a90cfd"
    sha256 cellar: :any,                 arm64_sequoia: "366f13e108bd45f1dbaf87143c94a0e0268b4ca45ee3fc8b59306ff6c168013d"
    sha256 cellar: :any,                 arm64_sonoma:  "930576306051af3b125bf29d4db7c835fd0e85c6c97f26b444b46d862ebc88aa"
    sha256 cellar: :any,                 sonoma:        "17145442d7c74bd40fc69e9535f6ba14fb6a6a928480b7e1269a005e473cca2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8c2104b2cc26950fb855b992fd9b77b351a8e16f7ba8bf5cc9d0d2284a4525b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3175f5af5e7692013405d173c47167ca0c3fa496d37faaa44dc00ffb026c5f6e"
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