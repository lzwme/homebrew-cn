class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv3.2.1.tar.gz"
  sha256 "2530b601224d96554333ef2e1504cebf040e86b79a4166616044f5f79c47eaa5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2787ea744f1817df259989bf5a4c81db5bb123bba4d6f2b04bf80d3a87a9afd2"
    sha256 cellar: :any,                 arm64_sonoma:  "e2430b7e67b7202853a19b6df05848f21e3b75433a744af58254eb9638dbe53c"
    sha256 cellar: :any,                 arm64_ventura: "000a02ababbf9600dbed404aff076b42e56d0216ecff4ba035429b7ba9fcb4a7"
    sha256 cellar: :any,                 sonoma:        "f12e8ff0bbdab253673d8c45de0c82c2f302bd5a28a71dfda2bb93f65efd6fe4"
    sha256 cellar: :any,                 ventura:       "8a9796fc37dbd632bba993b9d061539d476be6099eb4605e8e970532c640f86d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a0847da125e06e295234e102105e639e9c9520eec1acdc172b13d286b9dc453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2c76766f69e6db6a282804f33359245ac185b0a5f95a76ad4d4984f3ae8457f"
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