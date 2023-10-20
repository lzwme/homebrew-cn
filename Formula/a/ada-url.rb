class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "c750b6fe52ed82d57fd32df83218bf57ca66f273a4f9420db1df7917d6180175"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4155b7ba7553a89b616ace73f898d22a699048cb49cc4b9ce5c3764d974ea30c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b3b075c589d2f210392e54932a10f6f02fd499a5adb9a4824d9f2c5a774c141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07c0c0516f7ae492443c6e48a4b6815a28364055e015eb659a33f76adcb4ce0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "30c6715997b81679722ad0d06bc719fa6f7c1d8fabc57a352f9b828b6a064178"
    sha256 cellar: :any_skip_relocation, ventura:        "cc654b854ecf9b5149f9d6389d954ce48eb8a2f4844ac53c6bbc2700754a88b4"
    sha256 cellar: :any_skip_relocation, monterey:       "a864ec58fff79e3f1ffdf80947a57f65396d73c2a77f453b5930dfc5b9432e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a962b58a244ffc2cccd7a2e38ee0b0f0b6dda98b843eb7ef3d956ff5f64a259"
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