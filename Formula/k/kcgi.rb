class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-1.0.0.tgz"
  sha256 "7b846c5012cc49639456bb99ddbc7b9525168697b891535f9195818e5483272e"
  license "ISC"

  livecheck do
    url "https://kristaps.bsd.lv/kcgi/snapshots/"
    regex(/href=.*?kcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "05ab8d8a49a7628dc68a14efe5d8e590f0e7ef5d257b3a7958a9f6251bd6478b"
    sha256 cellar: :any, arm64_sequoia: "29d34ade3802fbb30d12e08633c4cf9cda91f409dca93235d7b221e352d5dbea"
    sha256 cellar: :any, arm64_sonoma:  "ef4517f73ea6d84b5d7a37ab3a1bb848dd0b16cc71584a81e72696280fc5ef60"
    sha256 cellar: :any, sonoma:        "8eea66e181211b644fc74ac58222d36ae19628966fac1a1adfc7cee02bd6fc81"
    sha256               arm64_linux:   "90cb10bc33f6f8e525d3cd9990034c257e444ff946ce0bf0e673a5fc7ddb9dc0"
    sha256               x86_64_linux:  "da5edc496977395ea94fd28a771b0a1afd96ead802df01bbfdffb936fd7784c5"
  end

  depends_on "bmake" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "./configure", "MANDIR=#{man}",
                          "PREFIX=#{prefix}"
    # Uncomment CPPFLAGS to enable libseccomp support on Linux, as instructed to in Makefile.
    inreplace "Makefile", "#CPPFLAGS", "CPPFLAGS" unless OS.mac?
    system "bmake"
    system "bmake", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sys/types.h>
      #include <stdarg.h>
      #include <stddef.h>
      #include <stdint.h>
      #include <kcgi.h>

      int
      main(void)
      {
        struct kreq r;
        const char *pages = "";

        khttp_parse(&r, NULL, 0, &pages, 1, 0);
        return 0;
      }
    C
    flags = %W[
      -L#{lib}
      -lkcgi
      -lz
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end