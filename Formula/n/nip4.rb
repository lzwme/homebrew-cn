class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://ghfast.top/https://github.com/jcupitt/nip4/releases/download/v9.0.13/nip4-9.0.13.tar.xz"
  sha256 "10330eb7f470b8774326d8a05698829e858af9c5f70d4392433abd7f2abfd56e"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c7b3f10eb45f3f7d83fad9c66505c3102fb15d9fd8943dae64799d4cd1b83e65"
    sha256 cellar: :any, arm64_sequoia: "8294ceb186f4a5ee6bb0b14a28a71aca5dcc5ca7bca487b6fe27de3f3caf6891"
    sha256 cellar: :any, arm64_sonoma:  "103fbdd0f4ccb8eb0e5bf2e2085fd453e42450fa5a396708250ff197ffdfef04"
    sha256 cellar: :any, sonoma:        "54298372de231cbf4076185f910c17bd89a5167827d91246813b7b4e7fdce665"
    sha256               arm64_linux:   "a4af1494e26c6eaec1b4c44239355dea7657797d6d54e7cd387d532cfa206f69"
    sha256               x86_64_linux:  "859c409f1c0f527a8d9a5f8b58c13d33786accd9d424269eb5ca78d81f4f2b55"
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
    assert_match version.to_s, shell_output("#{bin}/nip4 --version")

    # nip4 is a GUI application
    spawn bin/"nip4" do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end