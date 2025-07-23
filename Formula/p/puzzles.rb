class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250722.dbe6378.tar.gz"
  version "20250722"
  sha256 "6b2341440008168ad56601d02757ebde6d5a6776c6f58350c474de3b461cc130"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84f957af3dd6b9479e10baf43645854c332dbe936902e4850f005dfa155f0e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0fae458d42d5316412df68a2ae148596e48c271c7868df75c9a48991280df60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5bde140482f8b0e41e34b8e0db9568be50519ec1acfc64058a00f97210b15af"
    sha256 cellar: :any_skip_relocation, sonoma:        "09fc7969d20b72c59060abac026ff22090cb957db56f6d2d4835b1c5a523d693"
    sha256 cellar: :any_skip_relocation, ventura:       "58154536e903b74be79e793987f158220b0e1714d332a88e349810ea6c9b7ccb"
    sha256                               arm64_linux:   "8b3ad5bed5db3f931a0a69c305af2dd4fa483c123d95e264c2a723124f7cd9b6"
    sha256                               x86_64_linux:  "95140e6045af4fe45370782ce9942355fdfa1eca9e67af3441571e7753d0e37d"
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