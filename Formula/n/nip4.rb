class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://ghfast.top/https://github.com/jcupitt/nip4/releases/download/v9.1.3/nip4-9.1.3.tar.xz"
  sha256 "9800c28ca3769e32d83b24d8a9b860d6b34a80fdb8a401d4545e70c9291fba29"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "920feccd53084c42b5f25fe6bb9acd6284ca74710b26d2f62560ecf8481a1861"
    sha256 cellar: :any, arm64_sequoia: "1a2a807bcf5f992def9552a04517923bd6b983e6aade716773e19cd2083c29a4"
    sha256 cellar: :any, arm64_sonoma:  "65a042b2e012bd70fda7ee91ad9808e6b5ef39086f2a2e47ee5a73a6755a6eff"
    sha256 cellar: :any, sonoma:        "0b478798c2e47b620e04662c9a64d439ed6326b7bcfba93c14905bbfedd6e566"
    sha256               arm64_linux:   "424bada6c0e71dac69b647f5fb6969e217f6ab99788568f4c0913a123e5a73f8"
    sha256               x86_64_linux:  "58e78546735e1b65eb4a3d70d611cdfb86ace1c4767eb717906041a870ee9022"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gsl"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "vips"

  def install
    # Avoid running `meson` post-install script
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
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/nip4 --version")

    # nip4 is a GUI application
    spawn bin/"nip4" do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end