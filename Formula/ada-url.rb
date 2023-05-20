class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "d865ab8828c14fc1e2217ca9f5d7918d50775175b2873faf2fbda0085e0623d2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "947b217e7a623900f4d5d998b14b4680090ab5292b4097f03777b4544caa7ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d6f5d577b79553dbb138aa363e61d1857c7941aa939dc962534e1964b9f19b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f1ac2d66bc7d416aa8cb81e493a892acc2ef56ba73f378c333c5dc1854263e1"
    sha256 cellar: :any_skip_relocation, ventura:        "c778dc7497bb50babe1ca8114b632c1fdbf5ab54eb4563592548a2a92242ae1b"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ff892f585f2c2ea83db2898a2a80afdd317c89c157ab342a414833c215e27b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d90e9d849b6b006152e81965c3c995dab2e74860a0c53300cd659a57b7a982eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f268a1b259f2af843808eab28ffe80f6d94b1f31afeff1ca6fed0352bf7732"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on macos: :catalina

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https://www.github.com/ada-url/ada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output("./test").chomp
  end
end