class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https:github.comdiamondburneddissent"
  url "https:github.comdiamondburneddissentarchiverefstagsv0.0.31.tar.gz"
  sha256 "0e7ce9abfa6f8fb4c2c88a78ec18a84403d706ef08ceec955d173223835cb17d"
  license "GPL-3.0-or-later"
  head "https:github.comdiamondburneddissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab4d0479dea0c67a710b925414a9a55b2c3a739c481f975cc19515a6781eee64"
    sha256 cellar: :any,                 arm64_sonoma:  "24b07f98ed855ec93a1359daea34362b3c36d0ba68843240721e5fdd1f756bbb"
    sha256 cellar: :any,                 arm64_ventura: "fb20c945259afae12a0733fe88fe95677c1fdbbf2cf138ea36d66b76b341a447"
    sha256 cellar: :any,                 sonoma:        "4266a0c2b2772822ebe02932638a506f7f3feb0b11f627a7284d757ad0b0d198"
    sha256 cellar: :any,                 ventura:       "7b64be62c292d8503383de31d2b1a0ba209c1f16cc220d2f02ed8f702099fa9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8167873b835b53040a38b5d307ffdc2ee67f6b275032417b5f4a9ebfdeb27d5"
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
  depends_on "libspelling@0.2"
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