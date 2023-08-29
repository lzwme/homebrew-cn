class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "5b488e9a7a700de5d40a749c96c4339bcc9c425e5f5406a0887b13e70bd90907"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a11b9bde1b2effbbf90fe942675f87471db82991f45ae4f11c88e8578be27f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fdd89cb5afde5aec14953b53f39cbd6f02e4e71a6b63d2e2fe4e3b1020865b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3e4d368783c5449adb093719f8929134d9142dd04114fb62364799c5e67c276"
    sha256 cellar: :any_skip_relocation, ventura:        "309e8acc1368d98b40d0c930888322261f42534a39cbb201fb3ca29d8523abd5"
    sha256 cellar: :any_skip_relocation, monterey:       "e9a40393836e3952557e72759ff5644b41394fed1a7b4fa736dee4ef4b06ed78"
    sha256 cellar: :any_skip_relocation, big_sur:        "7687bc580468929419f8c2b7e8bec8190da512bedfdc2bfe26a615e06f2d4fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767af2a63a618abd741bb9d2ac495384c97b535a1c1fc6a4b6f46d2e768119f6"
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