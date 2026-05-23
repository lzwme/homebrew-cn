class GmpEcm < Formula
  desc "Elliptic Curve Method for integer factorization"
  homepage "https://gitlab.inria.fr/zimmerma/ecm"
  url "https://gitlab.inria.fr/zimmerma/ecm/-/archive/git-7.0.7/ecm-git-7.0.7.tar.gz"
  sha256 "cfc1c0745694e7b24a8a373d8e854f8ab42cff177dbd98beba3b093e3858ca8a"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://gitlab.inria.fr/zimmerma/ecm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1e7785b052a5bd0e6500f603ea2408f96fb6d41ecb6856855dd54db6386b1e9"
    sha256 cellar: :any,                 arm64_sequoia: "4d5f67adff90c862e4b85a8e3292bf63b4d93c5d362ced8f2575441b392e8766"
    sha256 cellar: :any,                 arm64_sonoma:  "76f07b6c8e39b0ea818de44ce2e5cea6027ff9a80f4955fd2725f019b8d7949a"
    sha256 cellar: :any,                 sonoma:        "4759ddec865273414af8373a30b4a17e0a01dfab539b4ae0393a935b03b12734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7500b4a76e6329df21c2930008e8884687663d66d7c11666ea563c94c4dbd020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3a28934ddb13feff78f9e5a3f7f1c0b7a8552848b3f3eaa8dc46506029dbe52"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"

  uses_from_macos "m4" => :build

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--with-gmp=#{Formula["gmp"].prefix}",
                          "--enable-shared",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # Test the ecm binary: factor 121 = 11 * 11
    assert_match "Factor found", pipe_output("#{bin}/ecm 100", "121\n")

    # Test linking against libecm using the P-1 method, which is
    # deterministic: P-1 with B1=5 finds 31 from 3937 = 31 * 127
    # because 31-1 = 30 = 2*3*5 is 5-smooth while
    # 127-1 = 126 = 2*3^2*7 is not.
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <gmp.h>
      #include <ecm.h>

      int main(void) {
        mpz_t n, f;
        ecm_params q;

        mpz_init_set_ui(n, 3937);
        mpz_init(f);
        ecm_init(q);

        q->method = ECM_PM1;

        int ret = ecm_factor(f, n, 5.0, q);
        if (ret <= 0 || mpz_cmp_ui(f, 31) != 0)
          return 1;

        ecm_clear(q);
        mpz_clear(f);
        mpz_clear(n);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lecm", "-lgmp"
    system "./test"
  end
end