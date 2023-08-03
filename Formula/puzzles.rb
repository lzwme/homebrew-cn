class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230801.0dd0186.tar.gz"
  version "20230801"
  sha256 "6f1efee869b9898fcab7f2ec99f15bd56867fbb87b43ca811a66fbe178e156a6"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61852212f036b54331ba62df8d117401a1fa7fb9ce573e3d21a786ffc0e84ba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c27678f93f63085e2fb957bef9aad3fbf33e49663b71299af1c178a37f5f2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbee75f5775df9fdeae1d9dc09f95729fdc19cc427a36e96bdf6a99cebf9561d"
    sha256 cellar: :any_skip_relocation, ventura:        "52f6ffbe915c054b146fdb659b17f3f1e49c1d6bc7de236541d61cdd6d10be72"
    sha256 cellar: :any_skip_relocation, monterey:       "62fee855366e59bd1e509ec9908309e09f8441ac02d7af2b0744774cf73bc00c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e0b41c37ab16222dd51a8dd6a1a0a9dd628560fca182b8250811f4d710cedd2"
    sha256                               x86_64_linux:   "29a7767f244d8423abd0711affe39d51db675976257ea5cebb909ed755028aa4"
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