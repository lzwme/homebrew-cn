class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.62/librsvg-2.62.0.tar.xz"
  sha256 "4278ddc1195ab82f4fd834ac1f5aa75ac1685f3cc5484bb0eaebe03a790b8d82"
  license "LGPL-2.1-or-later"

  # librsvg doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a101a33e6b20a55d07dfb522bff6d3fe3b0f4bd4c9e9df75a4e5b79b5f6d2121"
    sha256 cellar: :any, arm64_sequoia: "7769c2f29f71f4928413b7414343bec9246f33be5d764304d8f08763c518aa81"
    sha256 cellar: :any, arm64_sonoma:  "5c3ffd12ffd1309c41cbc0305aa63f91432a1ff85037a02b1639dfee8e1ce028"
    sha256 cellar: :any, sonoma:        "ceeeecbcc8cd4390bdd7b5238e9699460142893b88bc7ee78ef1422c36557883"
    sha256               arm64_linux:   "58fc9c93f1fe9983205ef4afe0fd1f2ff343ad4ca950783de4b55d214d94cce4"
    sha256               x86_64_linux:  "b0cdf6260ebb943168e0ed7f4897c6f4dcb0b3e28483ab483184db06fb538e70"
  end

  depends_on "cargo-c" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
    depends_on "libpng"
  end

  def install
    # Set `RPATH` since `cargo-c` doesn't seem to.
    rpath_flags = [rpath, rpath(source: lib/"gdk-pixbuf-2.0/2.10.0/loaders")].map { |rp| "-rpath,#{rp}" }
    ENV.append_to_rustflags "--codegen link-args=-Wl,#{rpath_flags.join(",")}" if OS.mac?

    # disable updating gdk-pixbuf cache, we will do this manually in post_install
    # https://github.com/Homebrew/homebrew/issues/40833
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dintrospection=enabled",
                                      "-Dpixbuf=enabled",
                                      "-Dpixbuf-loader=enabled",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Workaround until https://gitlab.gnome.org/GNOME/librsvg/-/merge_requests/1049
    if OS.mac?
      gdk_pixbuf_moduledir = lib.glob("gdk-pixbuf-*/*/loaders").first
      gdk_pixbuf_modules = gdk_pixbuf_moduledir.glob("*.dylib")
      odie "Try removing .so symlink workaround!" if gdk_pixbuf_modules.empty?
      gdk_pixbuf_moduledir.install_symlink gdk_pixbuf_modules.to_h { |m| [m, m.sub_ext(".so").basename] }
    end
  end

  def post_install
    # librsvg is not aware GDK_PIXBUF_MODULEDIR must be set
    # set GDK_PIXBUF_MODULEDIR and update loader cache
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "#{Formula["gdk-pixbuf"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librsvg/rsvg.h>

      int main(int argc, char *argv[]) {
        RsvgHandle *handle = rsvg_handle_new();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs librsvg-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end