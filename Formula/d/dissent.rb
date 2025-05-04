class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https:github.comdiamondburneddissent"
  url "https:github.comdiamondburneddissentarchiverefstagsv0.0.33.tar.gz"
  sha256 "1ea88cd525836d2e9f206c9d00aa3451ec6074590444d0f038eebd85f360b5ff"
  license "GPL-3.0-or-later"
  head "https:github.comdiamondburneddissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af1b646f9f20853dafa84a7a6aac667aef88e152ab8f99876aef4f97b09e729d"
    sha256 cellar: :any,                 arm64_sonoma:  "974e77c38894c01ecf57f2e3858feb165a57e98de9fff160f01f1994568321a6"
    sha256 cellar: :any,                 arm64_ventura: "41ae0e4ac1bc67da0eb165c2a4035f23c53daa0261da76cd9397b276ff09661f"
    sha256 cellar: :any,                 sonoma:        "e3a1010c05ca2f66312d26aa921c19d588448d5d8c4974b88dde7bc156a897d8"
    sha256 cellar: :any,                 ventura:       "1173d5f1e1d9def3ccb8d4f6b1006324f1059a438e4ac5e0bf20e0c90277ac3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1db665ec66c2e15621119579677df78d88c27b67f0f972458998d9432326f7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44ed9208399dea38391491ee9ceb550cb273cb8e9c1f5f85ae510fbccdb723b"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "libspelling"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Fails in Linux CI with "Failed to open display"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # dissent is a GUI application
    system bin"dissent", "--help"
  end
end