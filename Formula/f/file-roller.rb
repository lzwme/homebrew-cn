class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/43/file-roller-43.0.tar.xz"
  sha256 "298729fdbdb9da8132c0bbc60907517d65685b05618ae05167335e6484f573a1"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "16b06490765c501c70bd3d0db457196928e0876d7fba03f2ab968a34c0806150"
    sha256 arm64_ventura:  "912c7fb4afbc9cd54d953b77bbdbfe8569e75b8f16516edc34be4ba1151f26b1"
    sha256 arm64_monterey: "3e639f65b5bd29eb0cb94ce800af5c1a1825fc52baefd424a801fa3f7cc72dd1"
    sha256 sonoma:         "cd551c7219378d9c370723ca10bc698d29d2472bbc941c041ccdce4ffcae02fe"
    sha256 ventura:        "d0e1e4be37b7f14ab5bc0a5b2ea31d0be48cc03208d9468e60a2d1505671d964"
    sha256 monterey:       "321ee8fa8f9869c24dd61d558b0216fa0a56120f28f938b81968586b1eb0fcee"
    sha256 x86_64_linux:   "5775c3a3a29583805a77c4db02f9e06696f77f8d7ca46adbe95220f14dcc848e"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libhandy"
  depends_on "libmagic"

  def install
    # Patch out gnome.post_install to avoid failing when unused commands are missing.
    # TODO: Remove when build no longer fails, which may be possible in following scenarios:
    # - gnome.post_install avoids failing on missing commands when `DESTDIR` is set
    # - gnome.post_install works with Homebrew's distribution of `gtk+3`
    # - `file-roller` moves to `gtk4`
    inreplace "meson.build", /^gnome\.post_install\([^)]*\)$/, ""

    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dpackagekit=false", "-Duse_native_appchooser=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"file-roller", "--help"
  end
end