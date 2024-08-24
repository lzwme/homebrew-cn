class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/46/adwaita-icon-theme-46.2.tar.xz"
  sha256 "beb126b9429339ba762e0818d5e73b2c46f444975bf80076366eae2d0f96b5cb"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1250e68255e0bace6793697ce92c5c57b6eb56ef2b3d25ec4512708318f8bff9"
  end

  depends_on "gtk4" => :build # for gtk4-update-icon-cache
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "librsvg"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # This checks that a -symbolic png file generated from svg exists
    # and that a file created late in the install process exists.
    # Someone who understands GTK4 could probably write better tests that
    # check if GTK4 can find the icons.
    png = "audio-headphones.png"
    assert_predicate share/"icons/Adwaita/16x16/devices/#{png}", :exist?
    assert_predicate share/"icons/Adwaita/index.theme", :exist?
  end
end