class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder/"
  url "https://download.gnome.org/sources/gnome-builder/49/gnome-builder-49.1.tar.xz"
  sha256 "3b9e4798388f959e1032c6ace4a5fb7b4e588b6339fce4c22ec26abe869f8a2b"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "51cdeb30f394cb217e959c6acf4ad9c5b1810e16ee181c7e14918d30af36707f"
    sha256 arm64_sequoia: "af239f21f3c40c8ef68bb26b981aabfc666cd9b1f4172c78d8e6a7f2beccda02"
    sha256 arm64_sonoma:  "6d763e77d778c71ec7e4e6738a1cdd0a8f3d24aadc505821aa8c2f9804259e26"
    sha256 sonoma:        "ab4c9dca0ffd6452f1b3b844c25a5ab55f936a45893d0ff33cf84d01c6ed1d83"
    sha256 arm64_linux:   "d8ab1fcf56dfb66523ee6f6911582a7aba233a4b4e0ca32228a5ade7c4ebba91"
    sha256 x86_64_linux:  "29f014b1b89c9592b4297286056337b08b5e98525302963daa2e904f5340b84a"
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
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "pango"
  depends_on "template-glib"
  depends_on "vte3"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  fails_with :gcc do
    version "12"
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