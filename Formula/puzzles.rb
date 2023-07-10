class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230708.61e9c78.tar.gz"
  version "20230708"
  sha256 "b222e264c7b104bf8f747348f9cc010d3e41768bc924cad5d8fcc6c876acdfc4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2626cb5f1c49aa511dc1881f232a786c282963e171433c90216922ff3722cc47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c42ff4c11c67ca7b5b13bd098ec68e98d52b03743c3d00d70bf79bf3adf063e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5c38318e69aae224d543e8d490f4e5eb5ceeadd9ee5e5fe86d5b30c962240e5"
    sha256 cellar: :any_skip_relocation, ventura:        "2b7a1472b2993f25e9a7fe6db0cc667ce93c898b95aa8629b62a430f83630dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "7388ac456beb41307b7b672799155e074ed0db3731965f2e6a0a498addf51fb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a37751661f691adc09e350aadf644add926905d5055903b2c863711bb21f90aa"
    sha256                               x86_64_linux:   "54406ee0c06ad86d158e37738cba785763f5ff4be2261ebcc1339718211ba8a3"
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