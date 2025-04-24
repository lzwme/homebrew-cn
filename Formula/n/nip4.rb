class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https:github.comjcupittnip4"
  url "https:github.comjcupittnip4releasesdownloadv9.0.8nip4-9.0.8.tar.xz"
  sha256 "86d6293283688ada06638f9b1fcfa46a3e15731d128327ed1d4c7dd4b63f6388"
  license "GPL-2.0-or-later"
  head "https:github.comjcupittnip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "024ab092d2a6944d83b683ac1666021374a8802577cee864565238fd24fefd2d"
    sha256 cellar: :any, arm64_sonoma:  "d820691ffe75ab11a1975777783a102c8c76b9f533a34b85008f74f4cff4813f"
    sha256 cellar: :any, arm64_ventura: "6544ece14496ce3b503c83c122099c4e60191cd94c77cdd55426c92d68d585bc"
    sha256 cellar: :any, sonoma:        "d50b13e54ff0732df1f3d27930b727b289e27fa36b975fc15f23134ba2e7528f"
    sha256 cellar: :any, ventura:       "913004fbe287fae2db0a182649470ae30b3b91ee48b60a224cadd5f19a2e4de7"
    sha256               arm64_linux:   "bbb13bd262af5a6a20e7c3287d24d46e89aedde169ed3c22225b2a59fd4fc525"
    sha256               x86_64_linux:  "5c798b138e7e028fa2b0ae5373d017c3005e729edaa44e2fb268aa91f84ffd59"
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