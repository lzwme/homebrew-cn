class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230504.63346a8.tar.gz"
  version "20230504"
  sha256 "dcb11b3366e909235fecc5309ab254a968188b30790f0be76d41a5f911a0745b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "533fd878392c71e637aa514e87b3fa1e91fe0d229e54369d9b64d0ecc8ad1648"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d537b86d6cfe8246b296ed5580b754dc5b0f9be6814cd100cae299390a38c09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d798b696c5ae176a204a238b66aee4c041cf324eabd75f56316c1e4d11ef141"
    sha256 cellar: :any_skip_relocation, ventura:        "de86b94df24be45f80588d029ade84995a344998336464d0110470ab0245456d"
    sha256 cellar: :any_skip_relocation, monterey:       "6ed55307cf90b2f018e5a762a0e216a367b2106847edf6e306da682de79d3363"
    sha256 cellar: :any_skip_relocation, big_sur:        "32d34a0fab2a7f74821f631e7425ce8482068edb6651145b42ee6f1d02448e9b"
    sha256                               x86_64_linux:   "19c943ecb876d126bc54087fffaa33f02d731b57e1329e2883f6760bc288531b"
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