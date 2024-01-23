class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv2.7.5.tar.gz"
  sha256 "25a5d62fdd4950dbef785db5725675c15f3df2cf899a4a920449fe9a05fc6d00"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5acf8e7d55781b7c8df24e9b1bbe93f272ca3c7970dc36496843b2359b5bac8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c170fc34c5b45ff9a88c6ca458514eb4b9ce4d445d25499f2f137fc500a99e17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb4cb8366b4059c679329a5a7b3dc5e5af7eb2bed6756b6f17e61813225b8ee4"
    sha256 cellar: :any_skip_relocation, sonoma:         "759879c74edd9d62aeb011fe8c6ed153fb80ed7e6b672702a2be083781f44184"
    sha256 cellar: :any_skip_relocation, ventura:        "c621b0aa0c734e196e3bb0400640a6bce5f73804acc2c78370c7218802074860"
    sha256 cellar: :any_skip_relocation, monterey:       "2ceb9e3c9708efc56a4c587288e840bf1132417da6cab6db39411f1c182ffa9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e07f5ad5c45e9bbfc5db625de3ce712310c5e7e6b45dd078f398fde127655a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
  depends_on macos: :catalina

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https:www.github.comada-urlada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output(".test").chomp
  end
end