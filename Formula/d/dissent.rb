class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https:github.comdiamondburneddissent"
  license "GPL-3.0-or-later"
  head "https:github.comdiamondburneddissent.git", branch: "main"

  stable do
    url "https:github.comdiamondburneddissentarchiverefstagsv0.0.31.tar.gz"
    sha256 "0e7ce9abfa6f8fb4c2c88a78ec18a84403d706ef08ceec955d173223835cb17d"

    # Backport support for libspelling 0.4+
    patch do
      url "https:github.comdiamondburneddissentcommitb5e6a54c7407522930adc0b3cd39a8ef93bacd61.patch?full_index=1"
      sha256 "5ba24c584eaf67f9efedc39090e33972515c1922260824bcb5ade8ac714de354"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d7f234405d49d5cfa1e1733beccfc366d048a3aa78c0053e6fbf4ca799252f1f"
    sha256 cellar: :any,                 arm64_sonoma:  "f32284f6cc3f48c3bf61ca73388acbaa1fdbc02431ea3438894c412e319a50f2"
    sha256 cellar: :any,                 arm64_ventura: "a86269627f110e996110801ccbc4b823bb3acf0fd03ccc2227a99afa0122f338"
    sha256 cellar: :any,                 sonoma:        "42bddfde3dccb451a1bbb783a033e8e02156f379c61636a8847e633139210672"
    sha256 cellar: :any,                 ventura:       "8ed2bdc466979563c92fb34ef393377dfdce0b923fd97e24c3dae645fd0cd03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff0e60ec2380e91edf15eef9f71c2230b8eed1facf477810037fe66b414ef78c"
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