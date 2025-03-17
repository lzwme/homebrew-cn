class Flint < Formula
  desc "C library for number theory"
  homepage "https:flintlib.org"
  url "https:github.comflintlibflintreleasesdownloadv3.2.1flint-3.2.1.tar.gz"
  sha256 "ca7be46d77972277eb6fe0c4f767548432f56bb534aa17d6dba2d7cce15cd23f"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d715de5272e80063dd98da69a86bc4cdd0d6d69bc42361a81be32171dfb77f9"
    sha256 cellar: :any,                 arm64_sonoma:  "662879fcfbb601e3f2be9a13d517ca9ef438569c2b0af828f9c97b9ef814f8f0"
    sha256 cellar: :any,                 arm64_ventura: "6ca5ea66e8b50398757e7444d621c19e26e1c5e747f716e9b6c10390471068d8"
    sha256 cellar: :any,                 sonoma:        "84876c70546dd71f2cc77640bcae5fc6cbe028bea892fbd1daa7ac6eaa32de24"
    sha256 cellar: :any,                 ventura:       "0f36a9fb023bee735056ccaf445a54e42f506fc70241e8116d0986909924dc4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43caf9afd90b88354f9e1f8a2fdee0053e30abc350f2072a03f8e5205c5fae2c"
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