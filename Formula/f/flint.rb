class Flint < Formula
  desc "C library for number theory"
  homepage "https:flintlib.org"
  url "https:github.comflintlibflintreleasesdownloadv3.2.0flint-3.2.0.tar.gz"
  sha256 "6d182c4a05d3d6bfc611565d6331d02f94066a3be32df36ed880264afa9c30f4"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "839b5058a9e91b957e71680c87328b80fbcf2d8726cb7e23ed6d23e2e2634d74"
    sha256 cellar: :any,                 arm64_sonoma:  "bf006ac05be415eda95ee2ebc60518b65363dc19d86346b31e0f5fbdc499813d"
    sha256 cellar: :any,                 arm64_ventura: "0aa084847f6995bb50ceed260d102c2b815052a1fd41e9766502db6d930aeb13"
    sha256 cellar: :any,                 sonoma:        "e686d711a77241640d911df9b58d0207bc4d689e214128e7d2a735dd86a3d23a"
    sha256 cellar: :any,                 ventura:       "55d70f7cda2ad6e4017756afdddc487b0921cfebd10bf2959954021bbb3f90f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc4006406b1224cbe329b56c931cf881e6416bd19475bf09a7d109fcdf03d2d"
  end

  head do
    url "https:github.comflintlibflint.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    uses_from_macos "m4" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    # to build against NTL
    ENV.cxx11

    args = %W[
      --with-gmp=#{Formula["gmp"].prefix}
      --with-mpfr=#{Formula["mpfr"].prefix}
    ]

    if Hardware::CPU.intel?
      # enabledisable avx{2,512}
      # Because flint doesn't use CPUID at runtime
      # we cannot rely on -march options
      if build.bottle?
        # prevent avx{2,512} in case we are building on a machine that supports it
        args << if OS.mac?
          "--host=#{ENV.effective_arch}-apple-darwin#{OS.kernel_version}"
        else
          "--host=#{ENV.effective_arch}-unknown-linux-gnu"
        end
      elsif Hardware::CPU.avx2?
        # TODO: enable avx512 support
        args << "--enable-avx2"
      end
    end

    system ".bootstrap.sh" if build.head?
    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include "flint.h"
      #include "fmpz.h"
      #include "ulong_extras.h"

      int main(int argc, char* argv[])
      {
          slong i, bit_bound;
          ulong prime, res;
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
    C
    system ENV.cc, "test.c", "-I#{include}flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system ".test", "2"
  end
end