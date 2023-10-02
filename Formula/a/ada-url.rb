class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.6.10.tar.gz"
  sha256 "a43e1ea0bcdd7585edf538afffe1fc3303b936752e18bac545fa11729de088bc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a1ccef484c9a868cb10915a022e00bf747b3c7d2724f2ebea40d824b9cca7fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4b4bbe17fc420826bc4238986e8dac134c6a7aa4ab7fa8402133da3a50666c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0afb4029ed6e43d85caa45708f2c478ff909ac11a4a9a7531c06f6dffdd295d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "24d2d5d9c8d8c329a678496528f00daf506846469cea8a6844fa9d5534eec02c"
    sha256 cellar: :any_skip_relocation, ventura:        "ebf0dd30a9f2bd2afe301ee251ed2c8e8d3d21fa5afbc7b1b8028010cdce1a2e"
    sha256 cellar: :any_skip_relocation, monterey:       "45e23edaee4b3f2f26ed5c0f86e67a41e58e59f98ce0aa97d70b1a67bbf74157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "009aec22bbb3df66354fec6691ccfedd3d95da1bee0157d46ef1a28331e5a86b"
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