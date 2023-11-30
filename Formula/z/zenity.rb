class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.44/zenity-3.44.2.tar.xz"
  sha256 "3fb5b8b1044d3d129262d3c54cf220eb7f76bc21bd5ac6d96ec115cd3518300e"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "58f6bd294009256de48247741826763dbb2f1ee3dc1966305772771093b9d6f3"
    sha256 arm64_ventura:  "0a943f96225f31ea62330f3282898767dae00e1fb4baa5e2851d4949999a76eb"
    sha256 arm64_monterey: "c8e913d6babc1084a45d390d6a6fadccc4442fab9a4e59ff315c61c194a4d5c0"
    sha256 sonoma:         "601eeacf7910b7204534cb322e51ccb7db2cf44a5bf496342b32c0a6c221c5c9"
    sha256 ventura:        "851da896a01945f2a0ad820214528cd6f6811136ee8a0731bd0f688bf4b06f75"
    sha256 monterey:       "b5a73623e1540d24c32fd06c9b3b345749599265eb1305cfa21ee862738a6094"
    sha256 x86_64_linux:   "16f016ef6c4c2f486f58c04d691dc275f8dffb368dcaf4f160e4f9049e6b166b"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # (zenity:30889): Gtk-WARNING **: 13:12:26.818: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"zenity", "--help"
  end
end