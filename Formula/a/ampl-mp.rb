class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https://ampl.com/"
  url "https://ghfast.top/https://github.com/ampl/mp/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "4dc9e5e86e5b5c32764243e405f82b5168c300b85e3a5000485837cf0cfe3f69"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "166695612818fb39ea32b55fe4d58f7e89495faf99d008d35fe59ce6a290c232"
    sha256 cellar: :any, arm64_tahoe:       "8f55048c9b2ea9a3501ea2f6c368651ecd3371325ea2f32f3b79216fe3067fc9"
    sha256 cellar: :any, arm64_sequoia:     "6362a6b2e95c988449cb36a53599f4ea219752f7252edefd2a3566cfbe4736c3"
    sha256 cellar: :any, arm64_linux:       "9a33fb40feeaba970f0fbbb2ff193be6b841a72dd9c8c29f551d3d488e7a4b64"
    sha256 cellar: :any, x86_64_linux:      "606acadace4028e6846da525ceb2d568c0e75c5442c79137f20b9f18d520af23"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %W[
      -DAMPL_LIBRARY_DIR=#{libexec}/bin
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"bin")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include "mp/ampls-c-api.h"

      int main() {
          AMPLS_MP_Solver* solver = (AMPLS_MP_Solver*)malloc(sizeof(AMPLS_MP_Solver));
          free(solver);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/mp", "-L#{lib}", "-lmp", "-o", "test"
    system "./test"
  end
end