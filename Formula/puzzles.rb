class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230410.71cf891.tar.gz"
  version "20230410"
  sha256 "e89cc46bca08dd4c7a8d586309db44f2df5a8b21aff13ba824ebaf3a4a1231b1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63386827fe45e8fa55411f9b71454f76be2d89ec9c54269753b006ac5c05097d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e137051bb9fb3587357db43b3b3c095a65451d79814b349dedf39cb2b8ff3055"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45009433efa8fecddd49df299b689afef93eb53f9c32cb83c1f344d16cfe8e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "8feb1df167df504c7b67c9a26cd7df7f6b21146a97ad18677d90c0b85fc13f8b"
    sha256 cellar: :any_skip_relocation, monterey:       "525d633da7b0953f04f5aeea030cc9600de2ed06da3a1a0df0a81462a03796b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bed0af8f5128ace7fa33daf1b547afebd2756d0602d7c275aa618f8daa8f7a6"
    sha256                               x86_64_linux:   "cdf801382913083d985ce162105f8c6deb7f7649223f66578b31dc19677d6019"
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