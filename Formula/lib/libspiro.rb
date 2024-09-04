class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https:github.comfontforgelibspiro"
  url "https:github.comfontforgelibspiroreleasesdownload20240902libspiro-dist-20240902.tar.gz"
  sha256 "c573228542b3bf78a51c5ce7b0a609e8a2763938a088376230c452c4f9714848"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e6c0e8f96853f93c1e71f4f5d0dc37f2099c3eead452cf646008a86bf4f011b"
    sha256 cellar: :any,                 arm64_ventura:  "8e53ae07aa3311c53ca3c643228a98e7f86ad2d38677ebfb464b3a040b4b1097"
    sha256 cellar: :any,                 arm64_monterey: "a382c4b2fb7e62f881939d49824b87dacbcda93fc15da984bdf8042e48313a5e"
    sha256 cellar: :any,                 sonoma:         "a0d7eea25faa5f57bff880aab937e7e1f64a671aaccb19d753bbb64346fe608b"
    sha256 cellar: :any,                 ventura:        "a0b385caa7ee7f008e245bdd406ce397b1887b3ea579e3c0195c895177f9ef81"
    sha256 cellar: :any,                 monterey:       "5690d2a28d33080665c39683414c2d514004d67a3dfb9d219088a55c6e9d513c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc3b6c737e3088525cdb960e85d57106dac28ffe6976592ee11eb385a912965"
  end

  head do
    url "https:github.comfontforgelibspiro.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system ".configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <spiroentrypoints.h>
      #include <bezctx.h>

      void moveto(bezctx *bc, double x, double y, int open) {}
      void lineto(bezctx *bc, double x, double y) {}
      void quadto(bezctx *bc, double x1, double y1, double x2, double y2) {}
      void curveto(bezctx *bc, double x1, double y1, double x2, double y2, double x3, double t3) {}
      void markknot(bezctx *bc, int knot) {}

      int main() {
        int done;
        bezctx bc = {moveto, lineto, quadto, curveto, markknot};
        spiro_cp path[] = {
          {-100, 0, SPIRO_G4}, {0, 100, SPIRO_G4},
          {100, 0, SPIRO_G4}, {0, -100, SPIRO_G4}
        };

        SpiroCPsToBezier1(path, sizeof(path)sizeof(spiro_cp), 1, &bc, &done);
        return done == 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lspiro", "-o", "test"
    system ".test"
  end
end