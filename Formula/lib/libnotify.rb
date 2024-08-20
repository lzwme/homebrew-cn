class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.3.tar.xz"
  sha256 "ee8f3ef946156ad3406fdf45feedbdcd932dbd211ab4f16f75eba4f36fb2f6c0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2fff04fdd870fef44affe2aacd76d6bb9cb571ce4fe94f38da720f57f5b7c065"
    sha256 cellar: :any, arm64_ventura:  "1d8682206a13d9aad42501c9e4f2f4c9629342020daacf33a5e0e29e80e58b62"
    sha256 cellar: :any, arm64_monterey: "ca2cef7f1cdf9ce2ee7ce8ed88adf6c5926baf6c6361f046ea4e9d790b164242"
    sha256 cellar: :any, sonoma:         "b70bf3505162b27d87451d6e8bc351f845bcb0b8797d374e7a70da482e51c42c"
    sha256 cellar: :any, ventura:        "faa936783b93e58be323bfe52f05089f9b4b6e618fe8942792557ca2917d5d85"
    sha256 cellar: :any, monterey:       "ddbd98054cbf9e082bbd0fe42b78a3cd6d9c589847cebb5cf734307e1a555cac"
    sha256               x86_64_linux:   "8cd0d54a3afef2d7872337624c7677a5636489801fc3ccdfd3b2044a5667d88e"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "gdk-pixbuf"
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %w[
      -Dgtk_doc=false
      -Dman=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libnotify/notify.h>

      int main(int argc, char *argv[]) {
        g_assert_true(notify_init("testapp"));
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libnotify").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end