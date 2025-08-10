class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://github.com/nzjrs/osm-gps-map"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    # TODO: Make autoconf, automake, gtk-doc and libtool HEAD-only on next release
    url "https://ghfast.top/https://github.com/nzjrs/osm-gps-map/releases/download/1.2.0/osm-gps-map-1.2.0.tar.gz"
    sha256 "ddec11449f37b5dffb4bca134d024623897c6140af1f9981a8acc512dbf6a7a5"

    patch do
      url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end

    # Apply Void Linux's patch for libsoup 3. Remove in the next release.
    # This is a rebased copy of upstream commit that applies on stable release
    # https://github.com/nzjrs/osm-gps-map/commit/a7965751821d5bb55f8fb37b4045295d0c44dd9b
    patch do
      url "https://ghfast.top/https://raw.githubusercontent.com/void-linux/void-packages/f6b0cf8ca04678301773327b9a2d5efb043dae3d/srcpkgs/libosmgpsmap/patches/libsoup-3.patch"
      sha256 "045c8c9a6a317aea89158154818399815525f5b5cb0340332f92b250d73e5bc6"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "d3a211ac79c16396ead6f2534b86c3c248e06f831338414ec8a21bdc2cce22b9"
    sha256                               arm64_sonoma:  "5aa68d177f32672611f97b832c73c83570de2c6e86abe7f193ab734fafec8d24"
    sha256                               arm64_ventura: "acd4790bde4be13ced5e99b99379bb4aa185791d274130f55eddb281dd6d703c"
    sha256                               sonoma:        "ef15c14a0e3bba41a7bcf62813cca2c948e87a7b68ed8c8cf59085e0fb96ee19"
    sha256                               ventura:       "4cd079e99493a856504ab389073c91c59a36964e0fc018d8bbb9a2c298b4725b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f7c57b9e057b6958ee11fa4cbcfacd64bdcaa1e29b9f2a778b96c7057086778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68c94c3d3db5b48fa40523d5581d8794e00ce39a5f59b5a14924a2682fdc5a9f"
  end

  head do
    url "https://github.com/nzjrs/osm-gps-map.git", branch: "master"
    depends_on "autoconf-archive" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libsoup"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    # TODO: Remove next release
    system "autoreconf", "--force", "--install", "--verbose" if build.stable?

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", "--enable-introspection", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <osm-gps-map.h>

      int main(int argc, char *argv[]) {
        OsmGpsMap *map;
        gtk_init (&argc, &argv);
        map = g_object_new (OSM_TYPE_GPS_MAP, NULL);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs osmgpsmap-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags

    # (test:40601): Gtk-WARNING **: 23:06:24.466: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end