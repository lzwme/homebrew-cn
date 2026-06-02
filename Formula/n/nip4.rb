class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://ghfast.top/https://github.com/jcupitt/nip4/releases/download/v9.1.4/nip4-9.1.4.tar.xz"
  sha256 "589c5ab5ae8ed03fc64b6408f8a3ef3e827c2b1220a4d05c88821b00147b9ac3"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9e2c021a5447a5ce57a676227b17d8d3f7dc1e73a0e8bae014c74a5055d8bae6"
    sha256 cellar: :any, arm64_sequoia: "7e9c732d464b8492a26358ee5616cdbde826045e3b7e4f7042f22986aa1db451"
    sha256 cellar: :any, arm64_sonoma:  "8ce3d8fd6adaa52273d29b350c81b5c860bdd6adff8fbf6c5ac5047c43c34b2f"
    sha256 cellar: :any, sonoma:        "942d6e12c69f78977efb6f70f651f75bc9141213e02293eb5cc47f325e353ff2"
    sha256               arm64_linux:   "3f3580a1311fa118f948251025afec0639476ba6867651dbd940d75ae03a3dde"
    sha256               x86_64_linux:  "8f8344e179adc6e947c66c358628fdd4cf9fb18b86441ed8880cd55632b2d20e"
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