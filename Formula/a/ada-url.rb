class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "5599388dd6f380bb308f84539b1a5f01b23799c0ca0056253a5d97a03ba99b33"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42bec2c5b1cf57635a6421dbbb0752d29474932c2b54f16c8df6ae1582ae5a6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb097043ae27d0ad476fdb9b1b5be9083f9e7bdbbdc81dec537600f7230490f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92dee66f2672385d08dabb29529e48e7ad10fb9d33e5070ba44dca61be9c7cb6"
    sha256 cellar: :any_skip_relocation, ventura:        "d3f8160fa16fb0f3a6c59bdd32393bfa93707bf11687caf9e3a2092832f7ac36"
    sha256 cellar: :any_skip_relocation, monterey:       "969d50977a88e90aaf8d31120f273395598f2151b9eb427e373955a910b11b61"
    sha256 cellar: :any_skip_relocation, big_sur:        "341e43f2dcb07b95aa0939d9976f5af255036fcbe40e8299e2266e46b81be17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8bf1f7e69bb9bc19a426eb8442a903fa65c4eb5529b002e5f910777dd523332"
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