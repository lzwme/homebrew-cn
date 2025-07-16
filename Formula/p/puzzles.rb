class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250714.880288c.tar.gz"
  version "20250714"
  sha256 "325db97a98368abd0daa03c2416a499dfa99537c34a78a590870b67acba5d42c"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1bc4f3c2e258318fd6427af413df9a61f6131a353f28b2f354e3de505ea86f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44e3db2a995ffb99e6a1c0c5c5427c4d59676c9836d8ce3d6aa4796e1b7e0903"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f883a94b0b22110e644fd09bec8e8da57977381d8e07493c4f82f915ac859a9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f159d0064bc343672f43a5df901183d79757bbecd8ddf1aecea8493029a37b7"
    sha256 cellar: :any_skip_relocation, ventura:       "2de53da91bea0a843e853ad028a59fc9438e25a220089d6eee736d08da36990d"
    sha256                               arm64_linux:   "b09a790cc043531bdf923f68424cb44c40ba270173b522458c166ee7a0f8b216"
    sha256                               x86_64_linux:  "0063637809e0e4ae00b06e01230f0ddfaafca7e1aaa75233c928faa738d733cd"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkgconf" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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