class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://ghproxy.com/https://github.com/aruiz/webp-pixbuf-loader/archive/0.2.3.tar.gz"
  sha256 "0b6b416d8b4faa39f2531824b77174e33e5abbfdb4b4964476e5e427f53a75e9"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "02e8df532738cff9476f1a36c17c3761a48e7c353d64d45ae4808357811efe28"
    sha256 cellar: :any, arm64_monterey: "5593fd8798515b8044a23d858534679657a370280976b08fb21d427fbc0fa6dd"
    sha256 cellar: :any, arm64_big_sur:  "18bcd567ed47d664bae9b3c7893560fc3485d3e5b4fbce501cc00621df5c4bbd"
    sha256 cellar: :any, ventura:        "beb661238c0b977b8a3efb072bb0b74d4259f9bac053fc65f4877bc19d785d34"
    sha256 cellar: :any, monterey:       "12c05d3893e68b192180aa60e99ec32a76a27f25247a9d3136e74656df5bc72f"
    sha256 cellar: :any, big_sur:        "216316c3d931ed20b5730b0fd115131394d377084af18359a0bed067e652ee77"
    sha256               x86_64_linux:   "7a67b52b3dca17a5e0af1dd747ad52c471a3379066da79fb1b0605989070cbc4"
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