class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https:github.comtristanpenmanvalijson"
  url "https:github.comtristanpenmanvalijsonarchiverefstagsv1.0.5.tar.gz"
  sha256 "1ef7ea6f49f0eb59da131b9148fcb7ebb8f0d4d970bcd80d21c0ad77968eb619"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2329d1b8631829957aeb9664d43b1528aad3bcedabd161d5776939f5494d4245"
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp" => :test

  def install
    system "cmake", " -S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <valijsonschema.hpp>
      #include <valijsonadaptersjsoncpp_adapter.hpp>
      #include <valijsonutilsjsoncpp_utils.hpp>

      int main (void) { std::cout << "Hello world"; }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{Formula["jsoncpp"].opt_lib}", "-ljsoncpp", "-o", "test"
    system ".test"
  end
end