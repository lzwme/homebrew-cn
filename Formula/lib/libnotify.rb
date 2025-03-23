class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.4.tar.xz"
  sha256 "8fa04d4ebdc155b0a239df88bd9f09e8f2739d5707a1390b427ab4985f83d25a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "be9fea541f9dd869578a942e43e9e7b4f2462b96f6f51c54472f891627254e38"
    sha256 cellar: :any, arm64_sonoma:  "01821b19aea1ebb712811a7acb8082e468cae0d297185affd4ca1a152aed7773"
    sha256 cellar: :any, arm64_ventura: "515213c0803eef0e37a15413731641ee56175692eef55f12c3c67171ed00368a"
    sha256 cellar: :any, sonoma:        "6b10b6d544ba69ffd42f261b153f43f675eceb857ac1288c7bbc5c9f7a241d28"
    sha256 cellar: :any, ventura:       "d8decd9d63237513537284f5faaec68bdf474c4899d438cf76b022dc3afa3151"
    sha256               arm64_linux:   "02f1dd22971f47fbd7c896bf969c239b5f04c9627f641d4c0671b9e3e0b7a96c"
    sha256               x86_64_linux:  "e79d9d7b5f18b7236dc21e60ea6de33751a0a5bcf9b53d9ab6581346cc1684fc"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

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
    (testpath/"test.c").write <<~C
      #include <libnotify/notify.h>

      int main(int argc, char *argv[]) {
        g_assert_true(notify_init("testapp"));
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libnotify").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end