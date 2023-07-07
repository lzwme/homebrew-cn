class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230706.ad7042d.tar.gz"
  version "20230706"
  sha256 "fb15f32bd6e890e23dc89e2316a70d3384855801dfc11190e908b48807ecb91d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4ff44d706fbab74de013c9e38dd888707b07bc580dadac4a1ca9dfb7dbf2ac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd2911160599189f383b4bf5fa159bd6a5c706f0a2a936038feae086013c66d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a27ffd9a7f7c3333f40476b84e9bc9d1a08fecad133a67f5b264dd95255d0eb"
    sha256 cellar: :any_skip_relocation, ventura:        "a961f18b5196ee6d44bb122c6eae6b5127f48f1c68bcbd2c21972b314aaeac92"
    sha256 cellar: :any_skip_relocation, monterey:       "99e12aa1c9731a32a826ac2aee51e0c90aaf8f4f05c5f3b59d54e5f696277660"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ed5d88c5fdb01e5c555f00063ddc24719c984dad56480a3c07e7b6c9b4df2d2"
    sha256                               x86_64_linux:   "f3514324f98160046a5530333f481df40a1d0b06466cb171f2488af448a849b2"
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