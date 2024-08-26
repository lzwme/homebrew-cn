class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https:github.comdiamondburneddissent"
  url "https:github.comdiamondburneddissentarchiverefstagsv0.0.29.tar.gz"
  sha256 "1f3fb06b1621cb504500ad4112d74ac27024249c776e9d842438936b55e7ea00"
  license "GPL-3.0-or-later"
  head "https:github.comdiamondburneddissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a5d7791aff1ef644b7fe82a70ca4d512375c98e73415868e3aae912a87876e4"
    sha256 cellar: :any,                 arm64_ventura:  "c715aee49c907610cb6d6a30c9ab7603b4b4ff8f2de0f714209e726ff7c86eb6"
    sha256 cellar: :any,                 arm64_monterey: "65286c2fbac4c38dbd05b9986c05a1bc0e18d8ef57cf218f6990ff261743481d"
    sha256 cellar: :any,                 sonoma:         "b5b82d7603b89c98cd12f2322f50c382715b72dc6ca48e68af57756d4d7cb607"
    sha256 cellar: :any,                 ventura:        "2bc5723e51b1d6900ea19aab0b7d1abb361f0828fb3a56469383296006f458e8"
    sha256 cellar: :any,                 monterey:       "3bdef150b39747fdffd7600395b8e8fc01ac97cebc4230fd8dd0a130975004c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f9d3000949651617acba31373864c34dfa87eba8b5d2c54c437bff6ac444cfc"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

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