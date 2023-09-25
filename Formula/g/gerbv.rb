class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://ghproxy.com/https://github.com/gerbv/gerbv/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "3eef8eb8a2755da8400e7a4394229475ad4cf1a2f85345720ee1da135a1aec44"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "fb11deb70368edf98c01b48d9fb7efa5c739fb644b10f72b0f912317e06f26ba"
    sha256 arm64_ventura:  "a3d52691fec8e5390f999987c910f23c4d14818966a8b421a28e9ca104ff2314"
    sha256 arm64_monterey: "0af672d2466f08aadddc69dbe37e116133e333d3b02e76f9a76c5877b15a8291"
    sha256 arm64_big_sur:  "e7442945321db07ee1dd38ab656c10e97cb55eb14d22d612fae0379c4b731bef"
    sha256 sonoma:         "f17163930197eefcc707002fdcfb91bb1fe552f10c6a070bda590e1b6eedec64"
    sha256 ventura:        "08624343ddcd59b7e6b8114b40d8bc7f15ed907cc5da59e81be3760223d2f405"
    sha256 monterey:       "138d281e679f97ba780765febd8f85dea1bcae50ebedda9db96d8a91106623bd"
    sha256 big_sur:        "8ac4089a28578c37d40b9b852fc0ec2ce9eabde87750f4825fc9a0f7568d0fb2"
    sha256 x86_64_linux:   "8862121aa856803f96e1b305881e7c5e48d13f3a45c59155c4fbac1cf9227d39"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+" # GTK3/GTK4 issue: https://github.com/gerbv/gerbv/issues/71

  def install
    ENV.append "CPPFLAGS", "-DQUARTZ" if OS.mac?
    inreplace "autogen.sh", "libtool", "glibtool"

    # Disable commit reference in include dir
    inreplace "utils/git-version-gen.sh" do |s|
      s.gsub! 'RELEASE_COMMIT=`"${GIT}" rev-parse HEAD`', "RELEASE_COMMIT=\"\""
      s.gsub! "${PREFIX}~", "${PREFIX}"
    end
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-update-desktop-database",
                          "--disable-schemas-compile"
    system "make"
    system "make", "install"
  end

  test do
    # executable (GUI) test
    system "#{bin}/gerbv", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gerbv.h>

      int main(int argc, char *argv[]) {
        double d = gerbv_get_tool_diameter(2);
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gerbv-#{version}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk_pixbuf-2.0
      -lgerbv
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    if OS.mac?
      flags += %w[
        -lgdk-quartz-2.0
        -lgtk-quartz-2.0
        -lintl
      ]
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end