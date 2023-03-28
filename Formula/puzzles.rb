class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230326.8d66475.tar.gz"
  version "20230326"
  sha256 "6b11cae4962e39a6fd5617caa54a9e6ee8df2c4ccbdc416c8bdc9193b1046789"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f8a64d498b178652ea85b8e5e790933195357e7dc5cb598af1cd59aeda28cab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59faa25e2250b32239f0c130ec9c402b84980d7f834a38a84508240cc2489d0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7a70a50e71f2331db3fe7118d5475a41859d16aa8cb5bfba71a15f5bd6a1e6e"
    sha256 cellar: :any_skip_relocation, ventura:        "a6272e79d4f5ed0fea41297a9d95668befeb5ffa03f3b11f771ad0fce2f6c261"
    sha256 cellar: :any_skip_relocation, monterey:       "6921b47ac68c81012dc97e50f0ecad36892a7d0b8c8a516c096204546e8dd8f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "97d9d85b3415532c8b6d3c5293418dd8a166ffe689fcf72942ea7d7e2dacbe06"
    sha256                               x86_64_linux:   "243abd8ceb34e84fa853b2bc96e4c17b265f8ac883dc90c0609a34d53d0bcd1c"
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