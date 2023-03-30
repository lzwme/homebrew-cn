class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230329.4720eeb.tar.gz"
  version "20230329"
  sha256 "e6108c07a8c18e45f129c6939bcac740ab55843bb2288fa4bd9fe4d10b356760"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dc58481b50a6b204da2eea8648c089c0e6420a39adde2c5e1652301dac83a0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cd3d334270f9645c5ded8c36ec05659a946df4d2acd4eb9f7aa062ad4dc3477"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e13b2e266fca751b2c15364c3157a31e25efb547343a6d86bc1210b9569b0b"
    sha256 cellar: :any_skip_relocation, ventura:        "82ee4ea4bb9f9f197a5609d84b65cccbfb63b3f16771d136577f36cf6717a0df"
    sha256 cellar: :any_skip_relocation, monterey:       "e29e073bcd49032b2d93f95f95042972bc677eda9a4bbc9781370a56a5643fd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "731fd4211870ac6b2b1675a2c21cdf9859a00d7337f913a7250898b2f2fc57c1"
    sha256                               x86_64_linux:   "6e5cd27543083f7ab73bcc5f6964b7f6cbce794404749fd8945e3a1d25cb6d9d"
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