class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "8e222d536d237269488f7d454544eedf12847f47b3d42651e8c9963c3fb0cf5e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd6e0c1768dc3e44a8de7ed7e3b886e0af266039d56558b487548ec30ce8f3cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87382e8b8f0e71fb2c74436bd5f1b2cc88efcd88f1bd3c875418d8daf33204e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a637d5e6c96d6abe26fa6e10822c5f3ce9e6f599f168494dbb03dd9bf6b5a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d7cfeb21b62aed0ef2f2dcafd14489d9d62804cc22d76810765aaa712e7bdac"
    sha256 cellar: :any_skip_relocation, ventura:        "583dda61bc2cf171a814d23c1562cf79e0a57d2b72f0a110a5ee94e062d3b359"
    sha256 cellar: :any_skip_relocation, monterey:       "fd998a3a697f5dcd47e627648f8ccdf7c1058ed4a14143c9a7281ea592d90008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d2f5b6fad13a46a299ab9f497546c0ba18586a6e2dfb434dea94a58ec88b93"
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