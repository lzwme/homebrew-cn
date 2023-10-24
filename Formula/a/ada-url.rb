class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "4dea9dd6a46695547da2dac3dc7254d32187cd35d3170179c0cdc0900090c025"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f902e21f7da431d4e947414c382c83683d76f32906001a2b8a7bad6bc9339cfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "379959b0a3ecfd5ff94be2fbe0ac33d93f5413c42c764717a6ce0d9c24e25a13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "789f29fa605dc6d56af2c737ffc0e7c1ff575b7d775d8be566f08413f3a291d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "afd8bef2913fabf803e8c8e89a8a581812e944b2cd445ec6fb4beead6ea10c4e"
    sha256 cellar: :any_skip_relocation, ventura:        "01603806f85a4cbdfb6a6febf7db048659fcc8816629663f45539246b1767684"
    sha256 cellar: :any_skip_relocation, monterey:       "8f652451a1615be098f8f21c896440b8b7542a155fc94a256c963f8ae7ceabc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cfd8ecfbfdf4198cfdcdae7af574eecd740625100359476f52208b28d5a170d"
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