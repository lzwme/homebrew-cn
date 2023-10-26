class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20231025.35f7965.tar.gz"
  version "20231025"
  sha256 "73d0fc96be55ff506b2908c1b23f77d6e1a99e9479a7cd0280fd18fc735ce341"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c19a0e04263abed2532ddcf470f7faeef461c1aa1f7caab3943da0c36a6cd6c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61b223ed6ab9452f766ac06b6253dad28d724dbc8568ec6e29a1edf95a016aba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403ca739dea60e81ef9babcee04e3746ca5d6a2123f360d910a1a30e2c7ff7c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "33ceda13d23dd64bfdd9b40b610fdc0d473fae49f3f5b56084b4a20a19452186"
    sha256 cellar: :any_skip_relocation, ventura:        "5ce237b1293e60bd7943a998aac6156832610383672bfb5139d6237c5610bc52"
    sha256 cellar: :any_skip_relocation, monterey:       "a1c27fc5cd9dd0112482692f1a26850d2251e2667a1451845aaed6e8db89728a"
    sha256                               x86_64_linux:   "7ac30881dbd200f3c5b0cea251c2a73c47fdcc16fb9be1b4cebce3ea37e1b782"
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