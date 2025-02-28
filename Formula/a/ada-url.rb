class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv3.1.3.tar.gz"
  sha256 "8bd8df0413d57b56b32e6a5216a1c7f402a52edf33172a39e80484ccce0bb627"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d0c7d205062304e7987762407467db755f399a1571ad60800f32704e856e22e"
    sha256 cellar: :any,                 arm64_sonoma:  "1b65fd469391d24415b9becfd75a17b8152ce0a1f82bdd84fdf84021c2a3c761"
    sha256 cellar: :any,                 arm64_ventura: "f38f7af9255f3ef5af68360c08935b0b6e84bc9f16a2cb95a59573d91002fc7b"
    sha256 cellar: :any,                 sonoma:        "485bde8945602efba97f9b7f3bf57175701c54a4e212b3d74a63f4ba3d33b617"
    sha256 cellar: :any,                 ventura:       "ac3b862b510dc1d7277f92a0b6f3106c713014cf4c5921a62a22966829971e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e53bea71239ec13fb530aa3db57df9863dcdfa43878453d115f743c0c12f656b"
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