class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http:devernay.free.frhackscminpackcminpack.html"
  url "https:github.comdevernaycminpackarchiverefstagsv1.3.10.tar.gz"
  sha256 "6355776f60ebfeef63883aa02c19ab57f1ba776e43122f27cb3161e7fc277d1d"
  license "Minpack"
  head "https:github.comdevernaycminpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e0ac7bfa2fdedb96e6e90751dec4aed32528318c397aa8f90c7dcb51286e59a2"
    sha256 cellar: :any,                 arm64_ventura:  "00662bc1aa8ee430d61ed7ff52f2c77fa2ef1239b099f137f8727ba5f157e2a8"
    sha256 cellar: :any,                 arm64_monterey: "bde08e6279067da3d7a1140e031fe9ce6ae5f23e450d04799972cd605d991577"
    sha256 cellar: :any,                 sonoma:         "53de4275f881a04b906f818ed70f709e4f8b4e3c7d2ddb0b73086a5900989be4"
    sha256 cellar: :any,                 ventura:        "20ccbe51f38b6975afb3ffe4fbee044721adf9de050c7fc71eeafb57ee8d293b"
    sha256 cellar: :any,                 monterey:       "80c2b694c9438be2f9bfe0823cd69d27fc7d7032a761d6d27234ec915cfaa613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90c1b2e9eefa5f2fa8062d148390856cf16dfa51f123c0b5fe907920edcfbfd5"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMINPACK_LIB_INSTALL_DIR=lib
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man3.install Dir["docs*.3"]
    doc.install Dir["docs*"]
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <cminpack.h>

      int main() {
          int m = 2;
          int n = 2;
          double x[2] = {-1.2, 1.0};
          double fvec[2] = {0};
          double fjac[4] = {0};
          double tol = 1e-8;
          int info = -1;
          int ipvt[2] = {0};
          int ldfjac = 2;
          int lwa = m * n + 5 * n + m;
          double wa[lwa];

          for (int i = 0; i < lwa; i++) {
              wa[i] = 0;
          }

          info = lmder1(NULL, NULL, 0, n, x, fvec, fjac, ldfjac, tol, ipvt, wa, lwa);

          if (info >= 0) {
              printf("Success: lmder1 returned %d\\n", info);
          } else {
              printf("Error: lmder1 returned %d\\n", info);
          }

          return info;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}cminpack-1",
                   "-L#{lib}", "-lcminpack", "-lm", "-o", "test"
    system ".test"
  end
end