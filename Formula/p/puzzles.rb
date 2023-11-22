class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20231120.08365fb.tar.gz"
  version "20231120"
  sha256 "578387905d22ddd9ef4579a8d94288b626ebe03afcbc6d425f62f6ffd98bee9e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02230b568ab5ed17d9245a199143eb0ff6a9c2001a278c8ba17fb0a4ebdcbadc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36f01b6fa57ed551cbc9b07d387402742d9fa950d7372402026f6137844b438c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17897b448220b6535f335aa543871bdeaf6e605b59daeffb8662e4925412de2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "27ae8272127cf457353b6b3466855ad0c8ff999c3c261a2a68621c95839a743a"
    sha256 cellar: :any_skip_relocation, ventura:        "f0393e392b254542dac45652357b5789a9c39e2becea5994e1381b6ba046b2c3"
    sha256 cellar: :any_skip_relocation, monterey:       "5b962e55181ca7e52fde10689018fed32fc13b9b279f955ed215108d3f99d3b2"
    sha256                               x86_64_linux:   "e5119797c653ffd2cad06e9459dd63b6f02454032605ecd2ab295b4ce20e542e"
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