class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv3.1.0.tar.gz"
  sha256 "c93255bd9d3a5fa890843a34fbe9f7d2e233eea4b0c4075d401c32ac8e80a9df"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d29a1fe8c29e80fc1c4e67971dc0248212a668b9a99cf9595a687b8846ca61b6"
    sha256 cellar: :any,                 arm64_sonoma:  "855aff20e4e54fb21c21e95f81ae599a518322764716541ecf113106409639c0"
    sha256 cellar: :any,                 arm64_ventura: "7a360074ed6cb17f10147c0d38b31ac9f81d3de597cfb97d56c907b663c05d65"
    sha256 cellar: :any,                 sonoma:        "c12aebdb57629353d15f298d5adbb7f2fb625abd967e3bfbcb0c0ddfd9157b5f"
    sha256 cellar: :any,                 ventura:       "10e36bc046fa3991458c0f4145f94a63e5c96b3f4892fd79e4f858eb93160a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cff81c6cd7bdf4d5a066a99e3fe4aeadfe77e5a5e46af18ef51074beb035f3e"
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