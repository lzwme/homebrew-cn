class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "bf11c9d0cc1ee9e377080bdd8a3b8a8bf736ac7acaedcae882587e21b3e5625c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fce107a195c375eb7c945c6a2967461c6b8b493476478036ddc429bbb407fbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc218080aa81affaf68bc781f2f57cabcd5312f9f4466d331c7ac3ca8736646"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "630f37728b7b0edaa12f56c1ed5843b1ec492e5a8611fd94696dc6bc6176bd7e"
    sha256 cellar: :any_skip_relocation, ventura:        "f741fbea5aa355a6ef05d0262748c837b21333d060f4a1a7a7f1cdf91d752334"
    sha256 cellar: :any_skip_relocation, monterey:       "32be630da7a0567f2b3a194a194523dd1ddfd90809b7aa706f794436541764cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fe77ba0a44c69926ba230e9f9b7cf17ae7f796244b291279bfe53e0c087869d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a0c46cb4f8e83e518481237a5b13cdfdf12c2868ffc4163169bb265e74e8333"
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