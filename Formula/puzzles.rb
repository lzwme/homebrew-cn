class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230617.a33d9fa.tar.gz"
  version "20230617"
  sha256 "7f3eed6335378882bf03521b5aac3dc95b239bbc7137ed3e1f56f4d80c5c2d92"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbd2fec145ab760fdabb4d42114c5cf46cbfe303de0c494233d0f93d881e7864"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3856150806426ff67dac3188a59e5baacf520ce3db13cb89972c3ef750a4771"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d76d3038ef77559ec97fd2c8c3a8eb857335cd2d7a28aa18f28655d74b1462dd"
    sha256 cellar: :any_skip_relocation, ventura:        "81e13e0d352ff2274225e336a66d53ef0de08185ccd5652ea5955e8c2a234652"
    sha256 cellar: :any_skip_relocation, monterey:       "9731b0f8257f49a3f22ffc83318088fd4811e3adae702da779c4e8901ea11e48"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8dc6308c898954b2db1f1839ebdd2f7770fe27c1630a9d2845e16c872cf47a5"
    sha256                               x86_64_linux:   "801f0eb162847fb2b49c0014b425acab65ba3192f07041b300d6b5ccc10ab1a7"
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