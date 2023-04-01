class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230331.e6aa7ab.tar.gz"
  version "20230331"
  sha256 "0dc26fb19abc779272f2ebb2b0f9d7d110ff310a9043354191851d255cf2d28e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89f5b9a86e06c2e27412c404ba61901fbab01813ec7dcaaf4a837665e22cf0e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73c87c719d0c60eb126a009532f000e0972c5b656c085e910461b840ba73356f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c87b19d4f7308ab82e102c1be17dd53f5f29cb839c28cbab6dc5e5fda07d4b65"
    sha256 cellar: :any_skip_relocation, ventura:        "d99dd7c0dad5b1cccb924e9a9e048796aee4328c6adea6a49a40fb1a554e3f76"
    sha256 cellar: :any_skip_relocation, monterey:       "3122b060b7feee528e733ec7998f874cf151cb9e02b8cdc9c6f3e210de3e7a09"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f2748290c879720a3ef0e843810c4cb399a881396b4e8d536a742469d40ce5d"
    sha256                               x86_64_linux:   "c1f730d6d9cd0c26a0309a0fc3de4a22e61d2fb451d14e494b9c3b2902c29d94"
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