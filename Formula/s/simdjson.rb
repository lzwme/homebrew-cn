class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https:simdjson.org"
  url "https:github.comsimdjsonsimdjsonarchiverefstagsv3.11.2.tar.gz"
  sha256 "47a6d78a70c25764386a01b55819af386b98fc421da79ae8de3ae0242cf66d93"
  license "Apache-2.0"
  head "https:github.comsimdjsonsimdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09455b1073db304f87b26d44bec887eeb0307f03f7910ffc334ac20bdb5910ce"
    sha256 cellar: :any,                 arm64_sonoma:  "45cf413ed0a2afd5a814d76b8704cdc56e61c021319b4c6ed8a5a7f24966f70d"
    sha256 cellar: :any,                 arm64_ventura: "66a6e4d943e881dab72a3b0b914bc3876347dde9e734f75344c8f51353a4a8ce"
    sha256 cellar: :any,                 sonoma:        "c3c812557e6b3a8ae8e90cf874316fab8a4e0c25ae27d4b917ceac7b5ebb428c"
    sha256 cellar: :any,                 ventura:       "d1f6ac3de478178e4669063af19cf8cbf7f138120ad18faa604ed7eaade57015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ecda3bc3b21a11cfc34fc266428e453bd0f4e747c534051b8e14fb36e9b666e"
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