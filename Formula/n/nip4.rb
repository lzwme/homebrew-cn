class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https:github.comjcupittnip4"
  url "https:github.comjcupittnip4releasesdownloadv9.0.10nip4-9.0.10.tar.xz"
  sha256 "0e50978c042ff6a333fb9ca35ef0ebf6afbf0db43cbc5e122f2ab85cd6343c60"
  license "GPL-2.0-or-later"
  head "https:github.comjcupittnip4.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fd238ac604bf55da890fc707bf1bb80ffadd9dc1ad766b144126c87962cc293b"
    sha256 cellar: :any, arm64_sonoma:  "d6ff750c01f07b31c36467d421a3f01484c7890baa2a377ad50aecb78a832b76"
    sha256 cellar: :any, arm64_ventura: "35925f660cda79c56df59c1d6d41349963922a7d8dea9f5355a9eb7dda1c29a8"
    sha256 cellar: :any, sonoma:        "7ec3e005f73cad91afa08dbbfeefe515fc93ec6c09d5633e9c8fa55e3413e257"
    sha256 cellar: :any, ventura:       "6b4240a85a0e31e7194ae9ed6f46b30020b4a7f4d79841892444b37cd2ebb122"
    sha256               arm64_linux:   "5dadcb880663fe21aceeeb2c2ae9c12ad0b4ec9384fa18c91bb9b8038d8deadb"
    sha256               x86_64_linux:  "6d149e6b8c950983aac05133ffcea5ad0681bdab1da4363dfd7319da5aad9154"
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
    ENV["DESTDIR"] = ""

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}glib-compile-schemas", "#{HOMEBREW_PREFIX}shareglib-2.0schemas"
    system "#{Formula["gtk4"].opt_bin}gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}shareiconshicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nip4 --version")

    # nip4 is a GUI application
    spawn bin"nip4" do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end