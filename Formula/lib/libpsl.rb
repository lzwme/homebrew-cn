class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://ghfast.top/https://github.com/rockdaboot/libpsl/releases/download/0.23.2/libpsl-0.23.2.tar.gz"
  mirror "http://distfiles.macports.org/libpsl/libpsl-0.23.2.tar.gz"
  mirror "http://ftp2.osuosl.org/pub/blfs/conglomeration/libpsl/libpsl-0.23.2.tar.gz"
  sha256 "f2ea0e59bffb36597a872f6ef89893ffa4c30196c87eff7aeb2c47e4e8c98133"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d6dbe5f5903dc8a0e3667b783af379ad147776a34bc8928d67f29be430d98605"
    sha256 cellar: :any, arm64_sequoia: "117abeb239a574dc7ec9695dc00c1666c09c7cfcc289f418e94d417dc4ef2c7c"
    sha256 cellar: :any, arm64_sonoma:  "c4d97b158a12a1ae192d8ad4156d66c163855ca74982db3da6334cb495466824"
    sha256 cellar: :any, sonoma:        "8e78447cb0741b831d5f7c6f6ff529f18fb527ea8996aa53610b82571dbcc6c9"
    sha256 cellar: :any, arm64_linux:   "4feb7829f1319d5a9268cf6164735dd96feb45299f2743cf03489b95021b4448"
    sha256 cellar: :any, x86_64_linux:  "a7e76b26729382fed49aa584dcf7f2df252fb331aa8b9c897679bdd20713c416"
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