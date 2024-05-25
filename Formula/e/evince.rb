class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/46/evince-46.2.tar.xz"
  sha256 "8afb533cd6660fe4006339aaa03c0fe449e60d1042d25bbe51dc98fbee789f8b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "a6c5d4d71b91e958aaddd1cd5994fd364dc97bee5fa97826a89ec2afe6e20223"
    sha256 arm64_ventura:  "cbafdc50e6210f9615f5196a76bef1868d81e11f5cf7f24df276b73759204470"
    sha256 arm64_monterey: "e80c9d4542a258166ec0c64268ef7197484b663dde9d2ecee89a24a69d5deb8d"
    sha256 sonoma:         "fbd985b4e9a2878485f3ae835f86bce2447041c84bf31807c10399ad0f9abda3"
    sha256 ventura:        "015732ee78cf1ebb18f8ce7b107e747dfe940e3354530c043e85543f50feb645"
    sha256 monterey:       "54d2e083e0918e0949354f8a9378332d2775bbc83da8c2cb7f675171b97c3f72"
    sha256 x86_64_linux:   "9404383bb333a454b9293be57b3b0fa6e636207c4ad3003b9696eebef3e3d55d"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "poppler"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", "-Dnautilus=false",
                                      "-Dcomics=enabled",
                                      "-Ddjvu=enabled",
                                      "-Dpdf=enabled",
                                      "-Dps=enabled",
                                      "-Dtiff=enabled",
                                      "-Dxps=enabled",
                                      "-Dgtk_doc=false",
                                      "-Dintrospection=true",
                                      "-Ddbus=false",
                                      "-Dgspell=enabled",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end