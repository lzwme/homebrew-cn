class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230807.6d4b20c.tar.gz"
  version "20230807"
  sha256 "a08e7f7efe72f5d5a7b03dfb582e373be28eda82def13cb810c27b55b4f6bca4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6e434dc0e86a016315d671e3b3da176572367de6499a736c7ab800ac6bf6ac2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20196f148dd0b0b5af289aac265ddfa31b340601f4e3734dc08161fb5bf7ba74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5182148ef9fd40f2c9de8abe15fd7313522eec1a640adc04f99f52aec313b7fd"
    sha256 cellar: :any_skip_relocation, ventura:        "a341b1fa193ba2210abd39a2c25702ebbb358df85bc3251c071d28a882db32b5"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ab00fc0300f1541f3f3c97a11b053df11b8017d4c0ac7412dadae8abb41979"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dc5c4fabd7d72d4e406186d0c4a998c0a052f15f30714ef5916d507f5dd25d3"
    sha256                               x86_64_linux:   "aac89b0078ac23f4138f31de06e7c798f50048eb006baff871f354db2ec558df"
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