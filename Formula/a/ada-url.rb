class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.6.7.tar.gz"
  sha256 "882a0aa6e19174b60b2fa00ee75d35a31ecd5158fb97d0e4e719ba21bb07acb9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a75d4c7c9ee72c237402d2ce2daa72efe7f2057445ff3befbb226fff669181d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb4a5c8162015f7a7e74cc91621e0daa147952be389eb20a10906970c03f16e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b8836736b0c45a3fd6631115d1e3631e86b4d7f6f0cdade45984bd2545f3116"
    sha256 cellar: :any_skip_relocation, ventura:        "2dd803e61b56c9339c16cd92d267cbcdf7d4e7f634d3d028054b7ad2df25f4cd"
    sha256 cellar: :any_skip_relocation, monterey:       "917d0d2b89b62dab87720907a7a4b11459b182f245f7d2a2c92889319a81ccad"
    sha256 cellar: :any_skip_relocation, big_sur:        "925e1ad8742955d5aff22845a454481ebc4f9ea92b9fef08a6d4914a0d24966e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67517b56083cc930e9f1749556bf32cf64d93d741dad7bef8f0aa162d0696bf"
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