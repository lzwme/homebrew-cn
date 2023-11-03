class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org/"
  url "https://flintlib.org/flint-3.0.0.tar.gz"
  sha256 "b9086e31e3dab89896d7edbf05a5b758d5b4b72183a1a3478f23eabdcaaae044"
  license "LGPL-2.1-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  livecheck do
    url "https://flintlib.org/downloads.html"
    regex(/href=.*?flint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8d2a2e4923ae4a084f2bc54e4c39682f186d6777954a905a23245a773375e7d"
    sha256 cellar: :any,                 arm64_ventura:  "7fb4d8f1322617d55c70442af86565e3a1fc1d581480acfac1712d7f3e5e59e7"
    sha256 cellar: :any,                 arm64_monterey: "0c9f580bb8d76f9eafd2c109d43bfd0f83d344abc35a208b27950573dbd9b806"
    sha256 cellar: :any,                 sonoma:         "d58914cfe029e878907ac49ae2b08ba640e21c425dec77bf3ffeb14c4ac3c127"
    sha256 cellar: :any,                 ventura:        "51fc677fc7a3fc12bfbcf68cc8ba224cace5b743e3529acee1cbaedc970d4cdb"
    sha256 cellar: :any,                 monterey:       "ff39ca4802003425f500525083f1900ccbbe7475d5e3d6d2be32218c7418c71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4e172e634ad69d6dfce250fe31bb26064e8b32b56fc9bfc602f009180c7d2a"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"

  def install
    ENV.cxx11
    args = %W[
      --with-gmp=#{Formula["gmp"].prefix}
      --with-mpfr=#{Formula["mpfr"].prefix}
      --with-ntl=#{Formula["ntl"].prefix}
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include "flint.h"
      #include "fmpz.h"
      #include "ulong_extras.h"

      int main(int argc, char* argv[])
      {
          slong i, bit_bound;
          mp_limb_t prime, res;
          fmpz_t x, y, prod;

          if (argc != 2)
          {
              flint_printf("Syntax: crt <integer>\\n");
              return EXIT_FAILURE;
          }

          fmpz_init(x);
          fmpz_init(y);
          fmpz_init(prod);

          fmpz_set_str(x, argv[1], 10);
          bit_bound = fmpz_bits(x) + 2;

          fmpz_zero(y);
          fmpz_one(prod);

          prime = 0;
          for (i = 0; fmpz_bits(prod) < bit_bound; i++)
          {
              prime = n_nextprime(prime, 0);
              res = fmpz_fdiv_ui(x, prime);
              fmpz_CRT_ui(y, y, prod, res, prime, 1);

              flint_printf("residue mod %wu = %wu; reconstruction = ", prime, res);
              fmpz_print(y);
              flint_printf("\\n");

              fmpz_mul_ui(prod, prod, prime);
          }

          fmpz_clear(x);
          fmpz_clear(y);
          fmpz_clear(prod);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system "./test", "2"
  end
end