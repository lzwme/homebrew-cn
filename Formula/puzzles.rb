class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230227.5a491c5.tar.gz"
  version "20230227"
  sha256 "2bee57a5bf13b13fb4f2d8a29ea231a4bb91186181020af5e429bffecc37f810"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acc3977ba4d97e8c2d02bb5178aa404fbbdbb506300b9c1305aaa2c468d3b4d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b153d9c949fb66e936279a0f5ece302f91e4157ef2a8e962df453cce041a44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0bebe12743def2d411e92cc97745933b4ff69e8830084cdd84f5955368a5542"
    sha256 cellar: :any_skip_relocation, ventura:        "e5d7d6c700ae50ed842ed88eed7eea532eab028a1ef35ed1a43dea9b85ba54ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4db6a0b07fe00f5fe97ad2c0b3dbf65aea08aa5db7dd5645918ada61c92d51a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f69f3b1220c2518c4a176ccf2ccc46af985f6179abeb21601660e2466e329b64"
    sha256                               x86_64_linux:   "a53458302e03fcaf88b103fc205d37e410d40888ea2a23e128853501b7bf29b8"
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