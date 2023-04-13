class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230411.6fb890e.tar.gz"
  version "20230411"
  sha256 "96eb99305fe7b2276328164253cd19299ef35ccc13c3df08aac07ddb1c65141d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "510d0f2a7470eaaa68950f7a23d79e5b7e66b79352e1e4f1ca786777352b669e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ef0883bfba347860a7214129c54e645b09a6182b6c257c7082395b7e1fe5c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34cac20b91df84f00717e27149651caf881371896f7c609cbd68892e3218528a"
    sha256 cellar: :any_skip_relocation, ventura:        "e6d01ae8e30e38c907918ebf2224793e5130f1951687880f39c8649a0b647836"
    sha256 cellar: :any_skip_relocation, monterey:       "362188a44f306bbd3cf853adf49d8b019909f9355fe4636e701569ab8a3f98ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "934af13bcd8ea271a7b8df2e2340566fb4601e13366fdc5519947564c93eff60"
    sha256                               x86_64_linux:   "5e31f5100e3f31f9b029dbfd993e8e4adbcc9eb724a535c23249f01c39b59afb"
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