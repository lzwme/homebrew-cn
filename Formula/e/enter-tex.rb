class EnterTex < Formula
  desc "TeX/LaTeX text editor"
  homepage "https://gitlab.gnome.org/swilmet/enter-tex"
  url "https://gitlab.gnome.org/swilmet/enter-tex/-/archive/3.47.0/enter-tex-3.47.0.tar.bz2"
  sha256 "59a55f852ebb262aaca2f2380b85640ad380beba14ed1121e8beb0ba38aacccf"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.gnome.org/swilmet/enter-tex.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "03231ce34252328eb9e8c7efec64106f30379f93b205e3af0884ea48c99eecc5"
    sha256 arm64_sonoma:  "783266e0d1ddfe3dc11065a6d1d9c8ce086733d40230bb9f94d8681b8e23aa68"
    sha256 arm64_ventura: "7cedb4638ecc05158f6901eeac0d78559baa5f0db258eab3d4e317a8402094eb"
    sha256 sonoma:        "7c5a39b1cdf0039d77f1b199eacb42f1e2dc6428bea368cfd3468823e1277d9d"
    sha256 ventura:       "3790754aa36508b165ac2f7d834804a63bdb3b61ea675dda20e3c6fda4f637cd"
    sha256 x86_64_linux:  "857a05ffb43a92bb1ee79d3b725636f33ed10359e2e1fb2536208e4216360b28"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build

  depends_on "adwaita-icon-theme"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libgee"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["DESTDIR"] = "/"
    args = ["-Ddconf_migration=false", "-Dgtk_doc=false", "-Dtests=false"]

    system "meson", "setup", "build", *args, *std_meson_args

    # There is an upstream bug with meson to build gtex,
    # https://gitlab.gnome.org/swilmet/enter-tex/-/issues/19
    # and so build the Gtex-1 target first, same as arch linux package build.
    # https://gitlab.archlinux.org/archlinux/packaging/packages/enter-tex/-/blob/main/PKGBUILD
    system "meson", "compile", "-C", "build", "--verbose", "src/gtex/Gtex-1.gir"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-ft", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"enter-tex", "--version"
  end
end