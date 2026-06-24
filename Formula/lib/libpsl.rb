class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://ghfast.top/https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-0.21.5.tar.gz"
  mirror "http://distfiles.macports.org/libpsl/libpsl-0.21.5.tar.gz"
  sha256 "1dcc9ceae8b128f3c0b3f654decd0e1e891afc6ff81098f227ef260449dae208"
  license "MIT"
  revision 2
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "612197fd840036fc2c946c3550d814b63d4ac5e29eba01bd889d6c2c4047e147"
    sha256 cellar: :any, arm64_sequoia: "2baca54e155686829dbf5482311731c8f7978c7f5fbcf02a1f3826bf60f0d116"
    sha256 cellar: :any, arm64_sonoma:  "0b4d77a6438667c54b645fb6314bcc8150ed0a79bfac3493dbec98a6d2569076"
    sha256 cellar: :any, sonoma:        "df41fd194645b9d521a70cedd0cc1e5736ca7ad2d8002ffdaada282981b21fe5"
    sha256 cellar: :any, arm64_linux:   "68e82e2e15d8512e8a1ca94d0598dc68c61dc0e53a8f7f60679594867984211e"
    sha256 cellar: :any, x86_64_linux:  "b98808e409ada829e347489c6ed40a94d96f1f980688216b66e30d0c9c6c0b69"
  end

  depends_on "pkgconf" => :build
  depends_on "libidn2"
  depends_on "libunistring"

  uses_from_macos "python" => :build

  def install
    # Reduce overlinking similar to Meson build
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %w[
      --disable-silent-rules
      --enable-builtin
      --enable-runtime=libidn2
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <string.h>

      #include <libpsl.h>

      int main(void)
      {
          const psl_ctx_t *psl = psl_builtin();

          const char *domain = ".eu";
          assert(psl_is_public_suffix(psl, domain));

          const char *host = "www.example.com";
          const char *expected_domain = "example.com";
          const char *actual_domain = psl_registrable_domain(psl, host);
          assert(strcmp(actual_domain, expected_domain) == 0);

          return 0;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}", "-L#{lib}", "-lpsl"
    system "./test"
  end
end