class Flint < Formula
  desc "C library for number theory"
  homepage "https:flintlib.org"
  url "https:github.comflintlibflintreleasesdownloadv3.1.3flint-3.1.3.tar.gz"
  sha256 "3259e5ecbb07ea3bebeff025f846a494087be92b0aaf0636d6e36128963cadda"
  license "LGPL-3.0-or-later"
  head "https:github.comflintlibflint.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d057cba267ea669bb35954ccdc28acfa5ec41a958f6a2561ee1f0fc441f46ce3"
    sha256 cellar: :any,                 arm64_ventura:  "42d56a37bdb7120e4c9cbb5e1a92d5995168b8e26893d235089fd3f36f1fa1a7"
    sha256 cellar: :any,                 arm64_monterey: "068b313a597524554baa988c2dab1d08377d373e7c85a1fed7260c0c9f9433b7"
    sha256 cellar: :any,                 sonoma:         "182c134ae4ee00fac31c06d59cd77a0511569509a73425012b5462d05821f9ab"
    sha256 cellar: :any,                 ventura:        "9341daa4aadca4bc5c36a0cbcf46ecb81cf5df8cbcf7a9df4c8e5f4c8d82271b"
    sha256 cellar: :any,                 monterey:       "3446629a142b1fff5ece6b083ff5417736e091ee086bae449024bbed8b30901c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9505e259fb2fd8aa0e734cf1dc74b46a5a6a97c59a2561f51c1e24512eca750f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "mpfr"
  uses_from_macos "m4" => :build

  def install
    # to build against NTL
    ENV.cxx11

    system ".bootstrap.sh" if build.head?

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
        args << "--enable-arch=#{Hardware.oldest_cpu}"
      elsif Hardware::CPU.avx2?
        # TODO: enable avx512 support
        args << "--enable-avx2"
      end
    end

    system ".configure", *args, *std_configure_args

    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<-EOS
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
    system ENV.cc, "test.c", "-I#{include}flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system ".test", "2"
  end
end