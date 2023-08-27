class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "425b8696a28a22d19ee7aa4516c26fc8ae3ab574870a9a74ef58ba8a345b822e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc8a256c75cc2e99918da4a7361749dc9a140d5904e77b2b91c597e182801688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffb9e2ee8911bc7cdb41210cd7506a68b81b4183eca675a5e99625dc8265250d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e214e40e59caf385b65fbbb58a60552502a4401f06d8cc12eb4c9a3b13a67eb4"
    sha256 cellar: :any_skip_relocation, ventura:        "dbcde38c5a294a26a0c5da37217619f2b5364e6a003e8a5d9f97987b62379de6"
    sha256 cellar: :any_skip_relocation, monterey:       "389c8c3930db3bdb64c609e07bd48026a77203364a650a44eca8dce372ad5c95"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2ad7a3fe50345566b7547997ac047754521cdb0cc567c3cbf742586c1f843f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc88c8e419e5a80e2c1dbfe90e3f25e82d1b74eae976194b4b644f1b8b7e0fb3"
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