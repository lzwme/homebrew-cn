class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https:simdjson.org"
  url "https:github.comsimdjsonsimdjsonarchiverefstagsv3.9.5.tar.gz"
  sha256 "3d9e894a0ded85c000ec5b6ed1450ab4b037f44ba95eb3b0fefb4cda72cd9dab"
  license "Apache-2.0"
  head "https:github.comsimdjsonsimdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "348fe2059658b4ec99de7ede9c80e5c8eb377450f1f32b3b2a68f23abbd80bb1"
    sha256 cellar: :any,                 arm64_ventura:  "42486c63c21a4a09822a301486aad2ad0f207caec6c842d51644a6753f9ddd63"
    sha256 cellar: :any,                 arm64_monterey: "b5d9a33bfa2e70250fd6077de185730155f79b0bcf1bf004ca2e1f0a65247ba1"
    sha256 cellar: :any,                 sonoma:         "6af95e935d9807ec3b07c49f8969bfc2b78e100cce950c88b92cb72e06ec2097"
    sha256 cellar: :any,                 ventura:        "a6902c769161907602b8c340b9217adb67ffed2dc7cb24cda175e14d933eaf17"
    sha256 cellar: :any,                 monterey:       "e4d544ea4372c1d5ade3a8ef3e57347eb22efeee13228cf65398c09ebfc79c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b082f9fc2801b29df9009bdfd36c98bb84e95c0ae43cd3656083f7a1f444163d"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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
    (testpath"test.cpp").write <<~EOS
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
    assert_equal "\"Homebrew\"\n", shell_output(".test")
  end
end