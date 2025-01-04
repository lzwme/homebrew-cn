class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "http://gwyddion.net/"
  url "https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.67/gwyddion-2.67.tar.xz"
  sha256 "90aeaf4de00373696b0bef4a82ac45b6287ad9c7b7aca6249068d4d2a4fc8d61"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://gwyddion.net/download.php"
    regex(/stable version Gwyddion v?(\d+(?:\.\d+)+):/i)
  end

  bottle do
    sha256 arm64_sonoma:  "f3a7df065714d9c58d08ce3d3527fe746c16372ce5f0e040098743a9f45969f1"
    sha256 arm64_ventura: "dd772a7ad26e9f44004dda1f022ee8ec726811405b9b2d88236271aaaae083d6"
    sha256 sonoma:        "19960f4fc6681f9fee0fdd3b97ea90c90d764002d2dd8827923e99529e7f2dc4"
    sha256 ventura:       "644304817377de3c31996e105a4281bddb17da1ec24e1752649772eed70e2265"
    sha256 x86_64_linux:  "763473cb225de5e11dd37aa9af6669daab6deafb30c4cafdc6d27e8fa0a18f0c"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gtkglext"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "minizip"
  depends_on "pango"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    # Regenerate autoconf files to avoid flat namespace in library
    # (autoreconf runs gtkdocize, provided by gtk-doc)
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    # TODO: depends_on "gtk-mac-integration"
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", "--disable-desktop-file-update",
                          "--disable-pygwy",
                          "--disable-silent-rules",
                          "--with-html-dir=#{doc}",
                          "--without-gtksourceview",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gwyddion", "--version"
    (testpath/"test.c").write <<~C
      #include <libgwyddion/gwyddion.h>

      int main(int argc, char *argv[]) {
        const gchar *string = gwy_version_string();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gwyddion").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end