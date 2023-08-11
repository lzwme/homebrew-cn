class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230810.503f1c4.tar.gz"
  version "20230810"
  sha256 "397526e7159130c78db0152752457b86b508d8ab55ea69354e222944ff2fa637"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "914814f95ec8af834364bdab05b4af133c1ee9f59066937ac1b92c6e48afd98a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c942408b9e1bc6e45b1c976efeb53bd04da211e50307bcca0e2ff19479aa6101"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5de77d0c17d01181950ee546027175e9cc6e113e083e29e7d784672448b65e5d"
    sha256 cellar: :any_skip_relocation, ventura:        "dc2e9366212550bef7298f97ce4e5417711d385702f1cf5a0edbfd4266fe5bc4"
    sha256 cellar: :any_skip_relocation, monterey:       "f3a421950033b5ca74de4b8eb05044f0a559908ea8c684097362aa9fd7e9d77d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d686e50c7135e46d18894804452f2a6447145751f084274d1204561f70dfd7e6"
    sha256                               x86_64_linux:   "b73e9d5704d1b76e142c1eff5dd71dc7de30708cfff5b5b95898d9d8a781d623"
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