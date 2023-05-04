class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230503.89e9026.tar.gz"
  version "20230503"
  sha256 "b06777bfe2f001858bb0aa171fe9f2e30560ea4eaa88e593dddb94dbf54fd126"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ca10ae618a5566b60cbc898d6143944bee7d562431fbb76b2d2d31ef8c9f6a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84a804fcaecb6f172a51c26e2f138ae481afada83c095989c8ba7a2b47b5c53d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f23663288e6ecc4ead947b6fdc8a73b260270de6e633dcea1dcd2e1a16b4b65"
    sha256 cellar: :any_skip_relocation, ventura:        "662a237264a68bcb40728b4824ac29300977cfbfc6f7cd6b967af80ec3cb63f5"
    sha256 cellar: :any_skip_relocation, monterey:       "c42df1d4fac6c5369eb3332ebc72d039807763605f1554c673075057f0bfcb8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c7772fad08efd6ab179103b05a10e2b3cebe843319210f9d0adb2ffede2068c"
    sha256                               x86_64_linux:   "2bb7383b696edc540a05c1d6537547d6ca07e37aefef766c1c6930ccf3a3bcb3"
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