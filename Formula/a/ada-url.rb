class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghproxy.com/https://github.com/ada-url/ada/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "44140e2ac2eca455e106d4537340f8ceda3ca42bc1d1b88720e27785e6d4c34c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e710f65a39a6811bb65be9723d21f198296ed54471eac358abec4dbbe6b7e97f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d76fa2659c2eba1160ac856e290d37034fed4ec5a2562f57348c50b826dd4f9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a38c5c6a372740321055db0c98b46fe956ae24b884a1b10d51351b589c9b0f56"
    sha256 cellar: :any_skip_relocation, ventura:        "73ac998fe421e2fa24ae75a1c4db626dd802a750c41685bce260601620799395"
    sha256 cellar: :any_skip_relocation, monterey:       "411049de68f721439f47e36d6c13363c2b37bb56742ab96a63ccbc8013c5faa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b99f9fed880932689fbfa64170a0f19a6237b68c9053c19c27023eea4a0785f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2e95e0dad71a2cd0c1b4cab6ec08f2faf500c3914adfbc9696179cbb74b77c"
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