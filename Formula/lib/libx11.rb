class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libX11-1.8.13.tar.gz"
  sha256 "acf0e7cd7541110e6330ecb539441a2d53061f386ec7be6906dfde0de2598470"
  license "MIT"
  compatibility_version 1

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "3e6faf3d4501c50eb1fc7321adcb18186dc1f9d86e71adfeb5c381008525ad81"
    sha256 arm64_tahoe:       "42c1e92a711a2c323b0476b85dd3f481e005e61486b25044f9f4ae07e3bd9fe0"
    sha256 arm64_sequoia:     "5c92e4dfaacd0572841617a150ed85fbecb50d2274355d53d08dad10d963376c"
    sha256 arm64_linux:       "4300cc7459d6e52564209f84a9e899a57f8eed04c6ab5a9fb24a57c326518e6c"
    sha256 x86_64_linux:      "591e3d91a6823846b95d6cc055c95d3f062771f14ecf1ffc0715e4b05691e579"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xtrans" => :build
  depends_on "libxcb"
  depends_on "xorgproto"

  deny_network_access!

  def install
    ENV.delete "LC_ALL"
    ENV["LC_CTYPE"] = "C"
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-xthreads
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <X11/Xlib.h>
      #include <locale.h>
      #include <stdio.h>

      int main() {
        setlocale(LC_ALL, "");
        printf("XSupportsLocale=%d", XSupportsLocale());

        Display* disp = XOpenDisplay(NULL);
        if (disp == NULL)
        {
          fprintf(stderr, "Unable to connect to display\\n");
          return 0;
        }

        int screen_num = DefaultScreen(disp);
        unsigned long background = BlackPixel(disp, screen_num);
        unsigned long border = WhitePixel(disp, screen_num);
        int width = 60, height = 40;
        Window win = XCreateSimpleWindow(disp, DefaultRootWindow(disp), 0, 0, width, height, 2, border, background);
        XSelectInput(disp, win, ButtonPressMask|StructureNotifyMask);
        XMapWindow(disp, win); // display blank window

        XGCValues values;
        values.foreground = WhitePixel(disp, screen_num);
        values.line_width = 1;
        values.line_style = LineSolid;
        GC pen = XCreateGC(disp, win, GCForeground|GCLineWidth|GCLineStyle, &values);
        // draw two diagonal lines
        XDrawLine(disp, win, pen, 0, 0, width, height);
        XDrawLine(disp, win, pen, width, 0, 0, height);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lX11", "-o", "test", "-I#{include}"
    assert_match "XSupportsLocale=1", shell_output("./test")
  end
end