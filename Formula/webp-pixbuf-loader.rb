class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://ghproxy.com/https://github.com/aruiz/webp-pixbuf-loader/archive/0.2.1.tar.gz"
  sha256 "da967d3984e836cede32bb4f64413116889950d98e7804ac75597b62532e11c4"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4210ac319700482da14569dbda4208ec2710ab4d217b0e14adec5719b4bb0d0e"
    sha256 cellar: :any, arm64_monterey: "c52c1dcc33a847c641fe7b3fbc9549e8306883f1f9172f1542052c99f19573cf"
    sha256 cellar: :any, arm64_big_sur:  "91089f446b0ea1530403d212ca531cb9ea6f05082542f7ab9a2311023c251a9d"
    sha256 cellar: :any, ventura:        "52093a9dc7408ed00b6706f8dd6672f376b676ae29283874e943a69208368077"
    sha256 cellar: :any, monterey:       "da8ae47803816925737c3b8b6938b6af2b469ebcd6f236741de51325a14af28d"
    sha256 cellar: :any, big_sur:        "fd652cda16986f0183361c4840265979ee5f4e570a90d01f1cfb9807883a5759"
    sha256               x86_64_linux:   "c3f79a26ccf881fe613cee82910097ed3010b1bbb07f4c43d428552c910648e1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gdk-pixbuf"
  depends_on "webp"

  # Constants for gdk-pixbuf's multiple version numbers, which are the same as
  # the constants in the gdk-pixbuf formula.
  def gdk_so_ver
    Formula["gdk-pixbuf"].gdk_so_ver
  end

  def gdk_module_ver
    Formula["gdk-pixbuf"].gdk_module_ver
  end

  # Subfolder that pixbuf loaders are installed into.
  def module_subdir
    "lib/gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}/loaders"
  end

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dgdk_pixbuf_moduledir=#{prefix}/#{module_subdir}"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  # After the loader is linked in, update the global cache of pixbuf loaders
  def post_install
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/#{module_subdir}"
    system "#{Formula["gdk-pixbuf"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    # Generate a .webp file to test with.
    system "#{Formula["webp"].opt_bin}/cwebp", test_fixtures("test.png"), "-o", "test.webp"

    # Sample program to load a .webp file via gdk-pixbuf.
    (testpath/"test.c").write <<~EOS
      #include <gdk-pixbuf/gdk-pixbuf.h>

      gint main (gint argc, gchar **argv)  {
        GError *error = NULL;
        GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file (argv[1], &error);
        if (error) {
          g_error("%s", error->message);
          return 1;
        };

        g_assert(gdk_pixbuf_get_width(pixbuf) == 8);
        g_assert(gdk_pixbuf_get_height(pixbuf) == 8);
        g_object_unref(pixbuf);
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs gdk-pixbuf-#{gdk_so_ver}").chomp.split
    system ENV.cc, "test.c", "-o", "test_loader", *flags
    system "./test_loader", "test.webp"
  end
end