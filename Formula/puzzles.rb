class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230604.4227ac1.tar.gz"
  version "20230604"
  sha256 "b671b72bfcca313d90c3cea1d150afe7a4f1fc95fb991cf35e1eb28d6a623a14"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2932f556e1dcd6af505d866c00fb7151491d908805cbc627b7893aaff385e97f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b2657d93da3570a0a19af91cdf25f12a54eebc80f1c058e4934d16aa16ffa04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e74460529e125f5f727c1dc356f90a92b61f5a0c9b4d8e801bd8e8d579e13a5e"
    sha256 cellar: :any_skip_relocation, ventura:        "21b1cbd32cbb0116e5a8b7c79127f2e5f659d2fb7aef7d9440933d63dd90e8b9"
    sha256 cellar: :any_skip_relocation, monterey:       "c2207717eb0d7a6bf57c7f4847c8450060cf52c07e98137ec27a9a53519a8f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "02697c8cda37bddd499b24bbbda9112e894e987ac9b4bfb9e63bd180f19cdede"
    sha256                               x86_64_linux:   "93a7b99263a01de097abb111ca414e32a59bc2a194178b60f2e413d6db4af481"
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