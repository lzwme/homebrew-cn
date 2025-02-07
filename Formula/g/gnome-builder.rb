class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder/"
  url "https://download.gnome.org/sources/gnome-builder/47/gnome-builder-47.2.tar.xz"
  sha256 "4687b93c47cd1e33665a2dc503790b6213ee827872fc004d978d14bcbfa9b495"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "769b762a2898c798ba9884fd293a12314469c31262703f98e31d20cf3282b381"
    sha256 arm64_sonoma:  "81564920c5eff532491270e50d81c87707e2ab43eb8a15e8e300fb3d9f45ee06"
    sha256 arm64_ventura: "318d149743c4af9a6c7bec17ca680bdd57df930d39d90b35b1e0f2ed3e9c25bd"
    sha256 sonoma:        "b8d9b6084aa609f76600eec63304eaf1e9c83866a616104e7c845f9762ea63a2"
    sha256 ventura:       "64a1072bce7048dd4f476ebb8219ac6fb41ff9cdab19dd83d1ba0901947f0925"
    sha256 x86_64_linux:  "50092b5d53555c615c8953e69cc111b8a9a04b8bf4c9ed2c5fd92d0eb2a9b137"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "cmark"
  depends_on "editorconfig"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libadwaita"
  depends_on "libdex"
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "libpanel"
  depends_on "libpeas"
  depends_on "libspelling"
  depends_on "llvm"
  depends_on "pango"
  depends_on "template-glib"
  depends_on "vte3"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  fails_with :gcc do
    version "11"
    cause "https://gitlab.gnome.org/GNOME/gnome-builder/-/issues/2176"
  end

  def install
    # TODO: Remove after switching to Ubuntu 24.04
    ENV.llvm_clang if OS.linux?

    # Prevent Meson post install steps from running
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dplugin_flatpak=false
      -Dplugin_html_preview=false
      -Dplugin_manuals=false
      -Dplugin_markdown_preview=false
      -Dplugin_sphinx_preview=false
      -Dplugin_update_manager=false
      -Dwebkit=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    assert_equal "GNOME Builder #{version}", shell_output("#{bin}/gnome-builder --version").strip
  end
end