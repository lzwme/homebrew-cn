class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://ghfast.top/https://github.com/rockdaboot/libpsl/releases/download/0.23.1/libpsl-0.23.1.tar.gz"
  mirror "http://distfiles.macports.org/libpsl/libpsl-0.23.1.tar.gz"
  mirror "http://ftp2.osuosl.org/pub/blfs/conglomeration/libpsl/libpsl-0.23.1.tar.gz"
  sha256 "8fbb03054556498ba9c4cc48fcaa36a4483748c6504a65bdb9ba348f555b0e56"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c38c3245d2b76a345a811f75674bd6ead4b6c55e083bc8a968d55ea22f36d1b"
    sha256 cellar: :any, arm64_sequoia: "15d0b4ffc8d173f93e5baf76eadd797b44106e82cbb378a22793b263e78578f9"
    sha256 cellar: :any, arm64_sonoma:  "e4b441933cbeb974450689849db6fb37b9b0a177b47d829c6f6842cb5c0c0c66"
    sha256 cellar: :any, sonoma:        "80f2fec6273570b08ac5bcca63ed4da489ed86b1f3f16f61caf21f9dc43d2476"
    sha256 cellar: :any, arm64_linux:   "814bdd32417cb706952a9fade90e271bf77fc1e0ec3791963b8af1d8512fc89e"
    sha256 cellar: :any, x86_64_linux:  "f1450e6e5c4d7d0afbc078cdcee3015885c4542bd8a6c8221bf2434f4cdf7dcb"
  end

  depends_on "pkgconf" => :build

  on_system :linux, macos: :monterey_or_older do
    depends_on "libidn2"
    depends_on "libunistring"
  end

  def install
    runtime = (OS.linux? || MacOS.version <= :monterey) ? "libidn2" : "libicucore"
    args = %W[
      --disable-silent-rules
      --enable-builtin
      --enable-runtime=#{runtime}
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