class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20241223.5eea14c.tar.gz"
  version "20241223"
  sha256 "73d70f3f18d4ecefae029ea3cc291fbfc649795adc2e611f0fe9542b497e5fdc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "071195820547a40bef72be871a6716d0fb387f48ddb4e5accbefe18053731373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c1fda49b244e2f270cf4a760c96d1bb2c61c90db8b64607afa5fc4047563d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a922023dbfa93be3a0d277250d9287e6a63ce58fa4b74b1bb48cc6cd89954ae4"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa778639b8ad58b3a0fe6dbeecca3700551940b75a00c7bd0c5866bfd1849a99"
    sha256 cellar: :any_skip_relocation, ventura:       "b38902cd13ff5abfbb39835dc9502a3eb8c7bd43e209a056ecf33ac39f43c958"
    sha256                               x86_64_linux:  "1c20a81f52a01bdb7a9fc4d2be87c41035958f0bbdcfddca494a74c113a99461"
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