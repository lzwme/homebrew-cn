class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230619.da014d2.tar.gz"
  version "20230619"
  sha256 "7acfd7f2f101e4cf7b992706e68d7976a6f016b998bd582ce705548f7e1d857a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "112b13caf8c82882342d2cef6e96f4e42e07f656b46c959e951834fdde672613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cbd83a5b3083d2fdd20928ea9cbebca2de75fbd7861e863a556ad383f225874"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8506c77b53665479878cd9563b9c31485822a1a961c24c9c7637c5e5a6b13f86"
    sha256 cellar: :any_skip_relocation, ventura:        "e8dd125bc61103982035c294ff08db20d3a7d09e38d3726c10b28a5e0f90f415"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5d71879749fcb399605c77f421ae226b786d792381ff2b4fd246035a9e4ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bd06b01e73333cd9fe89de6d8eddb5d3b4b26b3e33f6ecc8d7a0f113d25e6e2"
    sha256                               x86_64_linux:   "96591bd58f17a453144e53e4184d7fd61e85365c4f4910a1fd66a0aac189d105"
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