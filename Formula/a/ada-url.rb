class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv3.1.1.tar.gz"
  sha256 "0e0edf137208fe66a8d215718d6a69154a9f2f59bceb2914c372d68df38d3630"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56a79d829a487fc2e92c2ff773f7bbf7c065ebaf31940d6eb60134790fdb6f1d"
    sha256 cellar: :any,                 arm64_sonoma:  "dffb673880fe615a9fc1fd76b3c99bab7b7c8ea78fa084bf88a45fb00856037c"
    sha256 cellar: :any,                 arm64_ventura: "9f32d817121ff54a32145fb8a5a29e271938611e7840da5499ffa3065484c3cf"
    sha256 cellar: :any,                 sonoma:        "94c20b144ea257b444134d35ce48bc5310fd31cc5ff625adb84b1de592fd1ef5"
    sha256 cellar: :any,                 ventura:       "fd771ee2631385f6e662c8d1c608b6bdbd157ac9a26fb4e4b8dad82ce0215daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26941cba214609b3fe2f534be64d79d99af6d47a8301411ab519b5262132f6aa"
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