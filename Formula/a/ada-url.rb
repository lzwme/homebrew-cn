class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv2.7.4.tar.gz"
  sha256 "897942ba8c99153f916c25698a49604022f3e54441cfa9b76f657ad15b6ca041"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "459321dda3d2adb61a9e5b2ed2dcfacda7295e525b75f1951547f936e5a7ff17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cba9a088506a29f1b3a5a91c2de3f9fc40adcf8dd9fb35a8e25865a6d468d9b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36b56a1a14fd61f4a6367e53568ca1d47d9a75b5ef559a416f8024bd65b613fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d42bdf597244206329f602487f096f2f6a02b580d2600b22a837f61fa23534f"
    sha256 cellar: :any_skip_relocation, ventura:        "e740b8ee37700c27edcf900990c05ae3442102c06ad901794f8d2f498e46c161"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a8f0fa0c2caf21333770fd0ffbc22cee47ef57c59ab8aabea732fe73f4d2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47186b02ec0839488f98e16003032aac753ee88acaec0c943840beab4f519267"
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
    (testpath"test.cpp").write <<~EOS
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https:www.github.comada-urlada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output(".test").chomp
  end
end