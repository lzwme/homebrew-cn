class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230401.91735e5.tar.gz"
  version "20230401"
  sha256 "60ea78fd026068e29ecb4d58957bdb5f415cfbb04199cfbcf5c5034445f265ee"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "086deafd3d474cb7a89b3334e4c7e7216a8df99dfceb579a8bd9fbf0675d5724"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc26bd7bb38b64f447739080f70054284dd0095a380f0df6b17008e9c149f175"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24375b04567581a0f8905495f09d9502637acd2b76fb99b17811279edf8f68b1"
    sha256 cellar: :any_skip_relocation, ventura:        "b4b34128237392e84c29f7f61201ff41d099a2189b65764f1221ccd3f5bc755b"
    sha256 cellar: :any_skip_relocation, monterey:       "5507b34c72efb48a39109bac783e095049d4a776743d550683e33b5ad8d4dc6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eae9f5034218c2405a2d89d58542dc9aaeef5ff90f773de0f5770c56ceaa164"
    sha256                               x86_64_linux:   "127e1ee898798186f5913c7fc06ff5375939dc3a858336b9d825a83466f6d710"
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