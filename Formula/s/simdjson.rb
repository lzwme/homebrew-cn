class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "3efae22cb41f83299fe0b2e8a187af543d3dda93abbb910586f897df670f9eaa"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a9a82d181534cdef09236bf27ba4ba0221d08019cb489f7a58a567962f3f8e58"
    sha256 cellar: :any,                 arm64_sequoia: "9496446a8b830d218c4d90a393f2193549080b746d5bc7e04d5b94b08bcf0008"
    sha256 cellar: :any,                 arm64_sonoma:  "c4faa10ed9771a5356edd4303d671440f3f453945f51e3bebf6dad21064f68b5"
    sha256 cellar: :any,                 sonoma:        "7743dc0f80a2473307c630f606547bd1939040a0ca4ae58930a2784762996100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8c951c7a3e8964c8d5035758a43bdabc0a96dae98574265fb14eb9211409893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53714d71210fff2df6223eeeb34464d680f49e155ede2030e8b51ed28af88245"
  end

  depends_on "cmake" => :build

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