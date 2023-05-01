class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230430.4de9836.tar.gz"
  version "20230430"
  sha256 "632efcdf27897e7c0f314a72ceabb27a6b01b4fdd44278bee811fec2b0f9e5db"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc89078fb8f744bf6bd4c2643cd09671f15f1593c1fcda07b9cc794abb7e5ac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28782b1105c1018e442a63cbd29ae6c4ed708f1cde8bb4fedfaf368e6b400bb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a35f9678934e3d6281bd87a4381ee0c94c9cded686eb5552070cea41a4e282cc"
    sha256 cellar: :any_skip_relocation, ventura:        "f593bba5cb8b40fbe8739f8dee45ed48946b3abb6a783627e874ae68cc29ae4f"
    sha256 cellar: :any_skip_relocation, monterey:       "1194a73dd8271209e53c3a2281228cf4a800ad406196e65265d88d53f94f864d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc09c73c3bed096f1ad2a42ae176e196e6a35cc241c016d5f41b8beb4d858bc1"
    sha256                               x86_64_linux:   "f1e40f82341f1518aa0b22e933833b41e203a4967058ba973bfcfe50b03ed4aa"
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