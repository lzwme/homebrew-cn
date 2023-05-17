class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "e9359937e7aeb8e5889515c0a9e22cd5da50e9b053038eb092135a0e64888fe7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa65ebb677095829402488a4ffcd1559a08793098328c302eea4715cb0c78c31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c40f0adbb4cb3673042c7076a5f533c48f7661a91022ffd3da4d352f89b99a78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb61e6a162ae43988842860e5d559382a43e42b1f43119be0830979c9a4ca08d"
    sha256 cellar: :any_skip_relocation, ventura:        "fa7838359773206fe4456efab7e579d2ea6b19af88d1b84fefd93319ebe795f6"
    sha256 cellar: :any_skip_relocation, monterey:       "0a53b025fa163dc4d6d877ba4df5c129c70e5e981f3623cf5242f313a037646d"
    sha256 cellar: :any_skip_relocation, big_sur:        "595b12ba1c31a2c43b71b2b105ead4217181b1b6e9ac2e6c3b2d7f672b11163f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "012c172dcd0c5d1a8efe54d2390743f187be44b08cf837d3c16d27170ad6ceee"
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