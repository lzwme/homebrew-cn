class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230328.2b1167d.tar.gz"
  version "20230328"
  sha256 "543dbc94b2e6a68cd0f9334ffb97403aa260a14f7ad3e61e55aa736bf722b31a"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aef17461fe0f4a6439d2d7147e165e4990b0c14030ea9431075c377aa0a5ca0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb7b4124952da797af378f8cd42d62246a23382d16f3915eeb8e3f31fb30bb16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27d7d15570932f279de4aa5cddd07fb21298656c75fb492e674bd0fdbb24aa59"
    sha256 cellar: :any_skip_relocation, ventura:        "55b96759a42aaed2ce06b3c287b9f8df0c7e12ed1c2314ef74b17fd878244944"
    sha256 cellar: :any_skip_relocation, monterey:       "47c4369fc6b28075dca15f337746e66a64905a6a44e39854fd56f54d811a7ab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ecde3973cc96b2077ab9e678a357cf82a30bed88d1418973a4702ce27e092d8"
    sha256                               x86_64_linux:   "e5529de34adca5742909aae69879687fb3c88a7749bfe97496bebc2cef4d2f94"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end