class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230715.6de17a7.tar.gz"
  version "20230715"
  sha256 "76fe8de27da77b8d5a747c3523b29127299e21e5d1eb93e2c30eb5f216f32ce3"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a231315e3ae33c7ee731205785b382b9453b90e95fe04e937ed11b5a55a2d87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ae32187cf5f5d15cbfbe1825476cfea3d902ac9ffb49991f22f51d7299436b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "138cf88a4ad4f9329f535e52d4b48f2c8c75528f21388786ab0d66721d27fa24"
    sha256 cellar: :any_skip_relocation, ventura:        "4aa27d42c864bbbcd457cfc12ab0952e7844148bf223f2437e462ec8fc164228"
    sha256 cellar: :any_skip_relocation, monterey:       "75f877ebc5632185c9d51f3b2702d07a92b2400d3bb04a0bbb2f460318168654"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc47914f7889b5a0e66a34090c4591904fd19470dd2ff42c978dcaa672172735"
    sha256                               x86_64_linux:   "8bc63a3ba5f24de251cb39d3aad6e8b237cc549cc23d93383a9b2c05778c4d0d"
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