class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230611.b08c13f.tar.gz"
  version "20230611"
  sha256 "1c6c09fd30d91f5f871532868f5135ea1b5e70a1ccb13290aa30355c241a0638"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a8a4eceb879f30ab47af820eabe505e2559cabeb298c05544d793264b0a25ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d76b3a29779873411273bb07e39fefb680a29d97ba903aac983dc192e1934d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3bf240ecdd6b3cbc256f305a29be7592751b4d175eeb3692577a41fa632228d"
    sha256 cellar: :any_skip_relocation, ventura:        "7c772e0d00a259b5a343e4bfdb66863c83d6157fec0325af2c7fe959a16f4f70"
    sha256 cellar: :any_skip_relocation, monterey:       "d8a52d704748b00a524155f41c5a1753a83e393247992f289c472c7b7c90b0b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "006ceda2d3e0493047752e486917056c09003af4df3d262377cc8e562951f65e"
    sha256                               x86_64_linux:   "f506f0934792774f7a5a890ec5a5c0e91ff892fb8b326eedeb8bb15cb1afabba"
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