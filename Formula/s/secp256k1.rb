class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://ghproxy.com/https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "ef2e1061951b8cf94a7597b4e60fd7810613e327e25305e8d73dfdff67d12190"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e32d424477c0f61fd7b604ad93ec422aa0d744169f26de0d09550adadc4c3a73"
    sha256 cellar: :any,                 arm64_monterey: "d385ce952ce29ad2ab9f33d02c5404b63c91767b7986a069711f9acdb534a054"
    sha256 cellar: :any,                 arm64_big_sur:  "a45f1e598aec64cb1a02788d6567e66654f053701bce3f033a242ecad4108f61"
    sha256 cellar: :any,                 ventura:        "c3927517aad3b15d931e69e0192d6b6be8883301e327e0bc3faacf7e871fd21f"
    sha256 cellar: :any,                 monterey:       "a0e0360ea1bcf9f75fb59e443e77107dd733e7709baf0992643bc8d6e9923312"
    sha256 cellar: :any,                 big_sur:        "9b1571fac73b29e67d7c5e36b07ba944a8b10db2fa295b23d6902847d4b47fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab86008470bc3287875e260776939b00de3d09db6ffd3efa4099cd4b76241abf"
  end

  depends_on "autoconf" => [:build]
  depends_on "automake" => [:build]
  depends_on "libtool" => [:build]

  def install
    system "./autogen.sh"
    args = %w[
      --disable-silent-rules
      --enable-module-recovery
      --enable-module-ecdh
      --enable-module-schnorrsig
      --enable-module-extrakeys
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <secp256k1.h>
      int main() {
        secp256k1_context* ctx = secp256k1_context_create(SECP256K1_CONTEXT_NONE);
        secp256k1_context_destroy(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
                   "-L#{lib}", "-lsecp256k1",
                   "-o", "test"
    system "./test"
  end
end