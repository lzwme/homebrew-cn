class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghproxy.com/https://github.com/simdjson/simdjson/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "942c9462b3c046e12b898cbf5e198f31a377ab40bb2bde5be98440d1f9212ee0"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "58580309bda349f20775bb7616cd4b193001fa006e77fd29030aded62299418d"
    sha256 cellar: :any,                 arm64_ventura:  "a967cc60c40da9f33918996b3e4c66c2bf93232259a3a237115b7285abe2b0e7"
    sha256 cellar: :any,                 arm64_monterey: "9a9539989a2644454df6f9d2ab0cdfee981e82588d801088a82ca39dda498a38"
    sha256 cellar: :any,                 sonoma:         "9010669d0cdc26369ac74b663e6a761d55e682041c8f6c42402d3819063f378c"
    sha256 cellar: :any,                 ventura:        "1d4a50a743d77e87a6b82c73bceff05155cc716a20e4d1a2b6e045d917fdd449"
    sha256 cellar: :any,                 monterey:       "b098fc70c3aa4d3a05b22efe8725b0ce7cd77ee7c933ba0f2a88cbfa666dc6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a76329eda91715a3a9b8ff67a17ed1fa918b61ab0ca914dad179ac447da84fb6"
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