class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/45/baobab-45.0.tar.xz"
  sha256 "a7d2cf308a6c839ee0b0bf074f8f5fd60d62ae2f064a94b3c610d6560b758e86"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "ef1f68b4bfa8df91c108145460ca781da7dbd9177ec02cd042aae5afcee6b01e"
    sha256 arm64_ventura:  "67e2f474770e54d21b438458c102257064b4fe936ebce7f7f1e511c3deaa3aa6"
    sha256 arm64_monterey: "9bb7893436b82350a739b5d66f4bc8c9b55c2fa23de4a74bf7b0f73d0728d1b1"
    sha256 sonoma:         "3490e08911e6251a53edc312c27defe582a97c720e0e1271fbb6cc0177fe3138"
    sha256 ventura:        "1f02d172c8b41de2ccb7de6f8e8006ed3844fbf6b5c2c745f9158a8441c73e42"
    sha256 monterey:       "cfad299814bea3271406e5a55cb21f894c80e1fe40d96fe594ea8de89947bde0"
    sha256 x86_64_linux:   "8659a7944031096bb3472a2210fc8dc350b65d7e417607d221dea0d41c951e3c"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end