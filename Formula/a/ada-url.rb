class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https:github.comada-urlada"
  url "https:github.comada-urladaarchiverefstagsv3.1.0.tar.gz"
  sha256 "c93255bd9d3a5fa890843a34fbe9f7d2e233eea4b0c4075d401c32ac8e80a9df"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comada-urlada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0ec7baa4bd1fee4eb4479194d095359d2c5214cc5fb2bc8324d7ac21a4a49a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad352edb0bb4aafbf0ffac0093c734d49077f2325039fe41aad082e03bec6aaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41403fb9fda15248c752323fdbf81d08ee6d704a79b6a04aa6372358674d1323"
    sha256 cellar: :any_skip_relocation, sonoma:        "93c4a4053bdcfd8d046a47e9e756f17fbb5e48d66880d68294484f1e530558c0"
    sha256 cellar: :any_skip_relocation, ventura:       "a804cbbe41f8ff60a65aed2046c3af90548bfc32f11fa200d2caa2f671e0e28e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f2f90e5da3460bfbcc1e74ef788f545cbb1f871d429272d90dcd55d5b87144d"
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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