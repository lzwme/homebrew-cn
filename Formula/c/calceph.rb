class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.5.4.tar.gz"
  sha256 "c9a834e823cf376de6c0f826458b5f19555ed45dfd26880781e61a91849925b5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d72af932e194c54a0ca4975e10b21398efa0aa66f69a0c7653524b3f28bae99a"
    sha256 cellar: :any,                 arm64_ventura:  "018c39035a43148383b9d2cecdac6a19dfd03c04137e26a312df60f54de26ccf"
    sha256 cellar: :any,                 arm64_monterey: "1d37496767c622b31e8a5556d422edd0761235696fea9d0ea0344e94fefd3c2d"
    sha256 cellar: :any,                 sonoma:         "f109ecf75bdc9e60e71c9c27ab1e60db2cb1e2dd28bcfa903910249acfe0955b"
    sha256 cellar: :any,                 ventura:        "6e3ffc023094c5c73fb3adb958571d0d17b468e762ce35cd202c7ffab91311a2"
    sha256 cellar: :any,                 monterey:       "15b10df9a3c51e21357934c7d469afc163fd362075070bf5882aa0c521f7f34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba6e76b7b38156fecb8ed3d497f64d0c6f582d2eef46420e9c4d3235dce0f192"
  end

  depends_on "gcc" # for gfortran

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end