class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "932a93f6a745775343ebdbaafca295e07b9513f6aaeb738f9e85dcb397925e33"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5905ef851943375fe6385f74a23ada42558be41beed073bebec3023a209635fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbfe6905df619b5c34af8265227f21cc6d1e9afcd862a52eeda333fb8cb943da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23fb7111179fd7a70939ad94390a58fa60384b9f8206c014d761fc4f17d049d2"
    sha256 cellar: :any_skip_relocation, ventura:        "c0c71c455e5230ea237ad0135c2dd5aa1d7eead41e46af224be37b5ca7b9412f"
    sha256 cellar: :any_skip_relocation, monterey:       "35f5d1b8982bf5c70772a908b2678b3082afbeeb5eba4e0cd1621ebc655264e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "81b465f1865bef74e9bedaf67932dc49d414fa08f75906128f8f66e2db46fa52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d854ec1c8fcc1712f99261590627bc6972a0a9d0b6ee24d197c8ebb914dd67"
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