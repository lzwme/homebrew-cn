class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https:scnlib.dev"
  url "https:github.comeliaskosunenscnlibarchiverefstagsv4.0.1.tar.gz"
  sha256 "ece17b26840894cc57a7127138fe4540929adcb297524dec02c490c233ff46a7"
  license "Apache-2.0"
  head "https:github.comeliaskosunenscnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c3531b7c92229eddcac3eff07698a8206621fda6af597998a6baea043373879f"
    sha256 cellar: :any, arm64_sonoma:  "f55a2dc6aceffc4955d9bdde6d9a85cc6d9fd4062f94760b4fae036a5ba0d812"
    sha256 cellar: :any, arm64_ventura: "1ce46536fa0d02263892e00a103d4302d2aad33beb1d9396e3956c7a894e34a8"
    sha256 cellar: :any, sonoma:        "466d7641baa693ed0a7d395a7b9742049f4fa62f978f8614c28806b7116a5a4c"
    sha256 cellar: :any, ventura:       "a98aae0486d5e6e67bc9a9245fe8ad6366ecbba04ccc0b600458de630bc8fb02"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSCN_TESTS=OFF
      -DSCN_DOCS=OFF
      -DSCN_EXAMPLES=OFF
      -DSCN_BENCHMARKS=OFF
      -DSCN_BENCHMARKS_BUILDTIME=OFF
      -DSCN_BENCHMARKS_BINARYSIZE=OFF
      -DSCN_USE_EXTERNAL_SIMDUTF=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <scnscan.h>
      #include <cstdlib>
      #include <string>

      int main()
      {
        constexpr int expected = 123456;
        auto [result] = scn::scan<int>(std::to_string(expected), "{}")->values();
        return result == expected ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lscn"
    system ".test"
  end
end