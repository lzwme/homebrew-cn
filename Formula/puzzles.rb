class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230404.4fcc1ea.tar.gz"
  version "20230404"
  sha256 "aab37efe5ab44d184f39f35b4f36f8cce9ac3197580afffc7cc4eed495686c95"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ee3de208562b959d1e733299ad960b62b8c1fc0fbbfbdd53bdadb72350baa8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16dde3b3177cbc905c802eb78ad96500fa4a9d62ea82b282fd8961a7d2ae2566"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cde30ae51ccb7f7ef62facb456e8b8cbc1da9a534f02c172817eb08d6fbecf5"
    sha256 cellar: :any_skip_relocation, ventura:        "22d8d303cf9eb03ef9fc7f842ec5bf4b2143b4a20e04f6becb01753992b01414"
    sha256 cellar: :any_skip_relocation, monterey:       "a94d5a02fe87b3f70046035b05e2318ae6132dc001eb7ec926bd48537954a42a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9738a20f117d65fc852ef88f6848e01671f7ce31bc091c298d909ac362d53651"
    sha256                               x86_64_linux:   "809f33e1911f6a7a10bd52756a2d7a32963fa0f76bd30d2f26ae6ac181894e1f"
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