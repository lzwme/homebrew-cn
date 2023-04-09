class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230408.d505f08.tar.gz"
  version "20230408"
  sha256 "24237175133bcc9e75c7f065a340ec25b6be658677f36e1424e04fb586e80475"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fef107de05ab779ba25e4afc38eb87bd130067ffdbce86dcf95bddf270f4623d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8afdf7f9d7488b5189fbc2bc9eae25faf919122afd05e3b17d67250d161210a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2513160f0e5a2964589391eccc80151ed76ebcda975d788d5858e26ac877aad5"
    sha256 cellar: :any_skip_relocation, ventura:        "be0378722d84f4f62f33014067160aaa2ca67452881eca61197800cdb0fc871d"
    sha256 cellar: :any_skip_relocation, monterey:       "58c8050828a89656e1ccf26a171063c91e4b907b70fe508a2787ff58323b8ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1c8f1a1cd0c3405342f3c2e56362902c860007ce1718fac90e204291eec2562"
    sha256                               x86_64_linux:   "e6c91fc0468e94b0ef77a6f927ba0c19259f8d90d06ca907e6a9dddbff332f52"
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