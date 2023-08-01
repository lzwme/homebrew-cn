class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230731.29eaa8f.tar.gz"
  version "20230731"
  sha256 "b3529583109032d75dd909a93e90ac101bd2539bb93229f6ff4f2224d209845c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c378c640e46615f0d49350b096e8f6afc1dd94e1490a77ac4c1a6613bfb5e3ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "457505f3d9d4b6c28b5bbcc0a6cf20699df3f864e2baec9d5b4685222eec188d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76772272b7954ba2d86b9129b85b66cc5d171bc7257e2c7563372c1cb1b51831"
    sha256 cellar: :any_skip_relocation, ventura:        "24dc38eae3e71f74e973df047d53231b8ee6c32684260f3c854bbff15e31bc3f"
    sha256 cellar: :any_skip_relocation, monterey:       "c50fab6bb8aca43bbcf4a903c906804d29a41c3ade8d49dbf419b6161bd40d71"
    sha256 cellar: :any_skip_relocation, big_sur:        "539bbd3df0f285b97810ff4f3f27bc0371e695d3f98b171572000741c0d4c976"
    sha256                               x86_64_linux:   "940f175b22dc4dd697ff9856ecbf2df4e56484e41e37341164eac71836a95ee6"
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