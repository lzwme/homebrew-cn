class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/48/ghex-48.0.tar.xz"
  sha256 "aa1d0ab5f74304aaa31987a182d421d63f19ce02465d7c642696e316123e30a8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "49b9b6c5b1d514547b0149124cf2442ef8b84583d9cb2c0b1a8eb1dd93d409ed"
    sha256 arm64_sonoma:  "ef17a612c186fd5e245f7df0b86c9b5c0c5df1e12bc089e4bc3992dafdeb2156"
    sha256 arm64_ventura: "8405627babfb8e2995d69f486a6c9ddfab87e4d1df6b7ca56dbf073de1be1203"
    sha256 sonoma:        "0e5187b6f9417ab226ee6cca61f1df3bf5dbc7d1836f20e38970699c9a2ccebd"
    sha256 ventura:       "a917fa05efa6d694ae8d1d06dc785e3e9539e04afb05aaa8f91e2fa931cb1d72"
    sha256 arm64_linux:   "3503e81b94bae1892beb464f58aff0f56fc21343c1c4f48344d7956aabb8251f"
    sha256 x86_64_linux:  "b8fc872f8a462a52609cd99c67f0a5e7c3f03a52f5665eb9460b9f086a323cfc"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # (process:30744): Gtk-WARNING **: 06:38:39.728: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"ghex", "--help"
  end
end