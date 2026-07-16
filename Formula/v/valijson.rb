class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https://github.com/tristanpenman/valijson"
  url "https://ghfast.top/https://github.com/tristanpenman/valijson/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "8e3cb09aead72f6f8653c966669cab52ff921ac52cc9d7498cd9387a35acce93"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f25544056f626c6310671ecfd45f8060ba1dc142c7f90ccb47b8292d64e18a27"
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <valijson/schema.hpp>
      #include <valijson/adapters/jsoncpp_adapter.hpp>
      #include <valijson/utils/jsoncpp_utils.hpp>

      int main (void) { std::cout << "Hello world"; }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{formula_opt_lib("jsoncpp")}", "-ljsoncpp", "-o", "test"
    system "./test"
  end
end