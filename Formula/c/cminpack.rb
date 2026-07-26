class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://ghfast.top/https://github.com/devernay/cminpack/archive/refs/tags/v1.3.14.tar.gz"
  sha256 "b3eff51610cd9b721705fed483cb47a08e5c17503b9820539a12c26776ce42d4"
  license "Minpack"
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "71691ec2300dd0ce311ee79d8f35f7ad94534f8c7c745c37b49af58540fe0132"
    sha256 cellar: :any, arm64_sequoia: "967e4f1735dd46357f40f0c2fd0bf65f2c94583ffd249bbe56cc416162da784a"
    sha256 cellar: :any, arm64_sonoma:  "23475c4f73263530ed97e25b37fa83c18ccd23327926327f72508ff76703f2d7"
    sha256 cellar: :any, sonoma:        "ce29cf331940f2aa412181ef2a806e4c9fd66d2712904602642a5aeea950e45b"
    sha256 cellar: :any, arm64_linux:   "f36d5ba236496aab48432d6764ac89b75b298004d00e0828b722fa71683a9eda"
    sha256 cellar: :any, x86_64_linux:  "e220e22bb3de55c9e3f5917ef1bcf3a4f4c8f3f81ecd2bd022448f2b104ad405"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMINPACK_LIB_INSTALL_DIR=lib
      -DBUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man3.install Dir["docs/*.3"]
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-I#{include}/cminpack-1",
                   "-L#{lib}", "-lcminpack", "-lm", "-o", "test"
    system "./test"
  end
end