class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.6.9.tar.gz"
  sha256 "d409a64cba23be6f603e7a521abab1d64b8d1bc1d228276be54cc2b50714c3c1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4c02025792952fd16e91ff85778fcfbef0905556bcddec8024081d180ffd8fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db1d7cce0f3e12927a7289d40e0e9d4b7c048fcde65d38580adf9ef63a27d0ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b8b9e590ad9aa7e2a73be3a33b63453d483e8125705b6ddc3e1c822c47b001"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d96be511c5290103a4d7673d57cd64826edfa699358839353254b844e86d870"
    sha256 cellar: :any_skip_relocation, ventura:        "dc8b00e75e91825bae7e228d754aeb384cbac45f4f0a93386f321cffa0fe616d"
    sha256 cellar: :any_skip_relocation, monterey:       "38d1c54bb830cb458b186385038926103300016e86e2290e9e12923517eede0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ce580668fa959c882c486089c9cc9eb4a5c9f40b64510a060a39f322211df66"
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