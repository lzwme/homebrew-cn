class Vipsdisp < Formula
  desc "Viewer for large images"
  homepage "https://github.com/jcupitt/vipsdisp"
  url "https://ghfast.top/https://github.com/jcupitt/vipsdisp/releases/download/v4.1.0/vipsdisp-4.1.0.tar.xz"
  sha256 "51a1105f27e495fdd8e55a8628c4f688f28f900475efc479c9a7202ba59f09c2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c9f3846017d8e88abe84648a4d2e44dccdb7c4d5abb59abf08d5b60c77255e3c"
    sha256 cellar: :any, arm64_sonoma:  "a04b7c9c63a8806c41ed262aeed0b940c9b84f51ca0d446f03e12753917f85af"
    sha256 cellar: :any, arm64_ventura: "2bfcc9baff915774aa2b17dd70e6a4fd87294fa801b1dc6e4138b2fe93b21032"
    sha256 cellar: :any, sonoma:        "3a0c948f1fa347a2a87a27006ec9baeac7487da201bcdbad0465801b9298d818"
    sha256 cellar: :any, ventura:       "ad37afb98fbfa1bbef6b6c4edef37f153009f49d57cb97bb600e655beaddc1c9"
    sha256               arm64_linux:   "0a489aaad7823803dbb7b7ff5ca367d7e9f10ad5df2a23c0eb572ce8761be11d"
    sha256               x86_64_linux:  "431ea15fde91d102763f0313ebb611279ca13b627d388db493bf1816d9edc679"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "vips"

  def install
    # ensure that we don't run the meson post install script
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
    system bin/"vipsdisp", "--help"
  end
end