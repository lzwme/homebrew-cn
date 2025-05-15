class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250514.49aad96.tar.gz"
  version "20250514"
  sha256 "190cc2c954a89ab50121ec11f3c7bc588f00e8a132b9b237de9dabc32dfdf669"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "811fae6295b9685cacaf55d6d96785548071686a26a710bbe70f6f071001ba55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a320b7ea3474ad6cf7de8b8c26420043af80c1314f7e008dd26f94161d36341b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c55edf5b858fd7a51219aa912580a7fed2e9879541d71c237b4cff4f9dc460f"
    sha256 cellar: :any_skip_relocation, sonoma:        "25efbcdbc0308fd27821e1b68a4a6926838d1bf8962e4daff83f3f42780e0af1"
    sha256 cellar: :any_skip_relocation, ventura:       "85f8f828868066e6b495aa72b9f4f9a9dfb0cc038ae3aee4c5a1b3f96b4f1855"
    sha256                               arm64_linux:   "54d510f834f659492ff267ed030ccecbf5e9e8d8a3cd99ccf0ba53ba77a28c58"
    sha256                               x86_64_linux:  "dd3f8599af0a1ed9170ee462d0884ba56df6b11a3e92799793e140e5f992ba58"
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