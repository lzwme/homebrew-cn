class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https:github.comaruizwebp-pixbuf-loader"
  url "https:github.comaruizwebp-pixbuf-loaderarchiverefstags0.2.6.tar.gz"
  sha256 "8d6db7f8a95df7649dccb9cfff1b922793427c0d59bc4d07723e3ba4c9e9832d"
  license "LGPL-2.0-or-later"
  head "https:github.comaruizwebp-pixbuf-loader.git", branch: "mainline"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7920eb4fe5c4438a41c28caa9658f36976e80abf4c1f45e62b7fd351e4279494"
    sha256 cellar: :any, arm64_ventura:  "e748879b57e281b041e832b36a7cf52001af3e8ad0f8de883ff5be1d2322139a"
    sha256 cellar: :any, arm64_monterey: "fe260164250e19d8a541cf4055bf5ad3e4fb1bf42e3cc0c63c4333699c002f34"
    sha256 cellar: :any, sonoma:         "ce7ac111df81088b252b19dcd840e0fabea5a9fc3e4038b04a1ecef91c751828"
    sha256 cellar: :any, ventura:        "360bfc878928087f778e2a4d8c54a667856bd6e5d31694bc7835bdfa247c7946"
    sha256 cellar: :any, monterey:       "3e6730f5c688937a539db6abb9b1e4d0f07455cfe6371d96639dc26d64c56d9f"
    sha256               x86_64_linux:   "8d794ff65a6fb176e9f5ed624dfa6ab71de19e0627e3d6721ec41d3e6984bd15"
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
    "libgdk-pixbuf-#{gdk_so_ver}#{gdk_module_ver}loaders"
  end

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dgdk_pixbuf_moduledir=#{prefix}#{module_subdir}"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  # After the loader is linked in, update the global cache of pixbuf loaders
  def post_install
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}#{module_subdir}"
    system "#{Formula["gdk-pixbuf"].opt_bin}gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    # Generate a .webp file to test with.
    system "#{Formula["webp"].opt_bin}cwebp", test_fixtures("test.png"), "-o", "test.webp"

    # Sample program to load a .webp file via gdk-pixbuf.
    (testpath"test.c").write <<~EOS
      #include <gdk-pixbufgdk-pixbuf.h>

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
    system ".test_loader", "test.webp"
  end
end