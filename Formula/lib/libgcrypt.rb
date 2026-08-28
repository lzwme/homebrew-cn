class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.3.tar.bz2"
  sha256 "98d1b0b3202d2b03fa754a35aa3cbbfcf526a3260d8d2ee213748001b1043006"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "21a6a5d04e73e33cb61a72000a1e3adf785e2fb81e0beca980b878ef3912a70c"
    sha256 cellar: :any, arm64_sequoia: "b006f4e8e2f4e69a7997ad2f0232d582591a3050bf6c3de337a0bafe01f0a8a8"
    sha256 cellar: :any, arm64_sonoma:  "207ab3c57910c3661b3aa2f51bc07e946c17c576173f74da2f81c1b3ee243fe9"
    sha256 cellar: :any, sonoma:        "e34a1bac9f4df523b3c05d7410c48039fc9470100d39880183a8c6495643f0bd"
    sha256 cellar: :any, arm64_linux:   "b9f066a6a9236f00f90c061583d0b2a3df7820fcd35f5158b1c792fefd896d4c"
    sha256 cellar: :any, x86_64_linux:  "f854464cd5716c0a1231b1f2642fa1cb46aa5181e5c734cad3d7225cd32db4bf"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-asm",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-libgpg-error-prefix=#{formula_opt_prefix("libgpg-error")}",
                          *std_configure_args

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "make", "-C", "random", "rndjent.o", "rndjent.lo" }

    # Parallel builds work, but only when run as separate steps
    system "make"
    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libgcrypt-config", prefix, opt_prefix
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match "0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6", output
  end
end