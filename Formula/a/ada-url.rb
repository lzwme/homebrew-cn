class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv2.9.1.tar.gz"
  sha256 "64eb3d91db941645d1b68ac8d1cbb7b534fbe446b66c1da11e384e17fca975e7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bffd7546e8c74661b85563c362c33895d4ddc1240430e7dfb4ec8a91f767d364"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a93c0ae5f4b3d28fff877354d02403fab55c164fb39bab28234f0a386b2fe444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79039e8503e54d41948570fd6049fb4465c2c4008eb5d2952812aee35954c6ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ce468f5063412b41291a76d785fb5fe35d023387123bb7f715a9652467ea3f1"
    sha256 cellar: :any_skip_relocation, ventura:        "9cb855875f0f7621e37037869908368feac0ce9d267da2d7495d56bb805f75bc"
    sha256 cellar: :any_skip_relocation, monterey:       "e0e0f967533a8f7077765e67983a5c4680a32d1b2c4d686ba2cdc7de04dbd1d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aa17587a7b7a75d510d207361e505cb2250b1ce288f86a06a8022423a4073cf"
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