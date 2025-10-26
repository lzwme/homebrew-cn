class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://ghfast.top/https://github.com/jcupitt/nip4/releases/download/v9.0.14/nip4-9.0.14.tar.xz"
  sha256 "a5bb0eabdbf5d6d6e1522e1a26ac158ed6a2b289cf47610b8d276fb876aa7b95"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ce931ce676fbd6c75f9d335cb18217460f422014217c246da368614134444df"
    sha256 cellar: :any, arm64_sequoia: "86e95ad4a634deec24f69306a212aaab2bf7de0864aeac67ccf92feb1d0f6c1d"
    sha256 cellar: :any, arm64_sonoma:  "b7c02517497fddd282b49cd6289fdde48139b8ec0ee7a7468d28dd46b2119bc2"
    sha256 cellar: :any, sonoma:        "b09530c9df764464bd0fcbeb5cd387e80a7f06a8ac7e8cc1239b4aa988ce9427"
    sha256               arm64_linux:   "f92cb7ba6ffc7597c1a698b48e6248a554cebbe935ecff41723630e12b685b11"
    sha256               x86_64_linux:  "58f553d06f4e3706a4b9d77a1cfc25119129c8955a55ac45067380ec4a90a289"
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