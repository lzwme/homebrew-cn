class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv3.1.2.tar.gz"
  sha256 "f9e9863571313de2e8326a2d634543137e7a409dba683e654b5ad9a4c6600f72"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "179c063815f30d7fe8423ca2a7836924ae6ada680366cec4c4968fdc16653fa5"
    sha256 cellar: :any,                 arm64_sonoma:  "abb8ee262ff43dcdb78041e0f4523fe3410b8b9eb71f5ffaf03f55659a8db618"
    sha256 cellar: :any,                 arm64_ventura: "fa17f6130ac83779429d32e016ce54bae8c7d781f60ffb6d6cbb75182bea63df"
    sha256 cellar: :any,                 sonoma:        "4793233a3edde82def02dd2b7ad65615f41e7b8cc8930bb5a7f36e45e6ede791"
    sha256 cellar: :any,                 ventura:       "b60d1fb9ac6e97114aa2770d9ca8509baeabfa6979178b1415793ad7ed2cbe52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52deb20bad2c64732ea2da22cd692a59bfe55eb3401660053257bc1e8a470be2"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    (testpath"test.cpp").write <<~CPP
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https:www.github.comada-urlada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output(".test").chomp
  end
end