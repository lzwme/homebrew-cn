class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.12/gupnp-tools-0.12.3.tar.xz"
  sha256 "ada36ba52068606ee97b157ba18d2cda21464c785ce2b5cbec4563aa9d2ffdc1"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 arm64_tahoe:   "ba2aeca1dbe6a96c61316e23e235a897a4ea3802ef21f7f823c1f91963c9dc0b"
    sha256 arm64_sequoia: "920ddb598f318165754f752038c1f47f365cdd3aa8b5792ab5be8fb9baef14e6"
    sha256 arm64_sonoma:  "dad6d65d979aca716c8d34144a2c2b5cdb1526aede30a5eff679f427ce0c67a3"
    sha256 sonoma:        "d21999fd7eb8fcac07b5956f30aba9bac52f3c91351995d06696d3a9ca0fe54d"
    sha256 arm64_linux:   "8c7d6b23f3e932f6239e5c3534df6e0785a6de236516369ab2108ba856bda645"
    sha256 x86_64_linux:  "4f6fd4e2cd4f3432d2506ec34a28b729a218a4604aa46a3ae209063d6f48b8af"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup"
  depends_on "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gupnp-universal-cp", "-h"
    system bin/"gupnp-av-cp", "-h"
  end
end