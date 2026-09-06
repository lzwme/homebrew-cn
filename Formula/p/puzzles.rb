class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260905.43eefe8.tar.gz"
  version "20260905.43eefe8"
  sha256 "87ce5b8258dd0c6270b4383d6325c894a77597337f874ceb2e5163210b6266ff"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8}(?:\.\h{7}+)?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c55e09c43c19403c8658aa48c62085847122b580a02664052b3384855dd26ad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bdbd3a1f6162609da14fe74fe9e9b70a8207d4ca9fcb0a9c61b0171a2743f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e6a1fc0b33e95d30a51de429d7054322fc75811fd103a218490cc160703c378"
    sha256                               arm64_linux:   "f9e4615a320cfb9d32d8de3e19a8bfffd38e6c9af497882ddbc4c54b33390d7e"
    sha256                               x86_64_linux:  "3b562146d7611cbf420bbf2c1a0ab3941fcb4320f4151f3ef379b6170540abbe"
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
    # Disable universal binaries
    inreplace "cmake/platforms/osx.cmake", "set(CMAKE_OSX_ARCHITECTURES arm64 x86_64)", "" if OS.mac?

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