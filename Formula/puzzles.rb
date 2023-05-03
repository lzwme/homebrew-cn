class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230502.e0bb6d3.tar.gz"
  version "20230502"
  sha256 "aa3fe48e75cef4940d5764110f1c89deffce65c2ba63b2bf96914df2d65b02ef"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "153b956e4d930018c297184aaf015a02a797b932f85605baf3c7c58e8caa8c51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca02342ccfa0bc064a6e8b8c98289afd569e5fa7ba5443413051f1bfa1a004a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63d7d315a867be36f948845b29f1f062b607c49c262f0ae58f291909a629a373"
    sha256 cellar: :any_skip_relocation, ventura:        "2fc914d018fe17e1706e2fe0d57e3cbb5264e1aea28d601be49f9c996b24e2b5"
    sha256 cellar: :any_skip_relocation, monterey:       "868cf65bf7565ec65ae9026482e259d6cb8deb9ca4b964c2a251d65958983350"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4555297b79fe7d2b12bcf8b880999e3da611ea90a3ebaef7b694deb608205f2"
    sha256                               x86_64_linux:   "08f3ebde18e08e5ae32a22e462b355c477787183292575ec7fd00c3dcd435b47"
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