class EnterTex < Formula
  desc "TeX/LaTeX text editor"
  homepage "https://gitlab.gnome.org/swilmet/enter-tex"
  url "https://gitlab.gnome.org/swilmet/enter-tex/-/archive/3.47.0/enter-tex-3.47.0.tar.bz2"
  sha256 "59a55f852ebb262aaca2f2380b85640ad380beba14ed1121e8beb0ba38aacccf"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/swilmet/enter-tex.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "7ac379dcfee03b15b58b59ca75120b281a4f2fb8f4e3960bc69882344e749c79"
    sha256 arm64_sonoma:  "fd0d1d740954163948e9793884f38c7251eab917bea0454785fe9bef1eead1c5"
    sha256 arm64_ventura: "6146c2de5b3c49b9ff014d12015ffb50a047e76c511af0f7cbf7646be7b4f7c6"
    sha256 sonoma:        "ab45e328b4dc56a6f0e107afabc6471885230195791083d60dc8e39e552d3e23"
    sha256 ventura:       "405e0c0beb03513ca2d9191b8f5c65d9a445444667d85fc2ed451dd18207155d"
    sha256 x86_64_linux:  "efa430c72fb6748d2183ad8c1508eeeb045f2e44ef91b8914e81e8b2297f53a5"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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