class Mpdecimal < Formula
  desc "Library for decimal floating point arithmetic"
  homepage "https://www.bytereef.org/mpdecimal/"
  url "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.0.tar.gz"
  sha256 "942445c3245b22730fd41a67a7c5c231d11cb1b9936b9c0f76334fb7d0b4468c"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.bytereef.org/mpdecimal/download.html"
    regex(/href=.*?mpdecimal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e13217b5255c026d0a0c7bbe911e3a5d380dba2c7301e50d3cff3eca4cb74e17"
    sha256 cellar: :any,                 arm64_ventura:  "34862cb6ffa2cbbed6a744f44418ef840346534fdfff1b74072444e73675d6ec"
    sha256 cellar: :any,                 arm64_monterey: "a674eb065c75a2278ded69d32ed5bf668dc16b9358d55f5cfce3d9cf0c62dddd"
    sha256 cellar: :any,                 sonoma:         "af88117fc62324b387772ad7afb1d201532a3c4df73e07748efc3bb36d1a7926"
    sha256 cellar: :any,                 ventura:        "4f12155286292dd219784ca5e353f5593636c3b4a27c1e6d0063e779c0a7eb59"
    sha256 cellar: :any,                 monterey:       "d221a65ac14939540c67765b31b60b8b2fea7adee53aec2fd9b09d1aec430e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5479e581f8ee8ef36877be191952527ec959b548250e2ebee684118959046e6c"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <mpdecimal.h>
      #include <string.h>

      int main() {
        mpd_context_t ctx;
        mpd_t *a, *b, *result;
        char *rstring;

        mpd_defaultcontext(&ctx);

        a = mpd_new(&ctx);
        b = mpd_new(&ctx);
        result = mpd_new(&ctx);

        mpd_set_string(a, "0.1", &ctx);
        mpd_set_string(b, "0.2", &ctx);
        mpd_add(result, a, b, &ctx);
        rstring = mpd_to_sci(result, 1);

        assert(strcmp(rstring, "0.3") == 0);

        mpd_del(a);
        mpd_del(b);
        mpd_del(result);
        mpd_free(rstring);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lmpdec"
    system "./test"
  end
end