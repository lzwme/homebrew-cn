class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230728.9e4e15f.tar.gz"
  version "20230728"
  sha256 "9ef02d3e421d181835c63712174ed607f37441599d739eecc44b63ead50f404e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8778565abf1e407fb68a77c741df0d051208105133fad0af15e6c38d4f3dce09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91342ed6c6b9295c878e51f56b7739236813755c425eeb02e675c0a1333da049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9c771abacf774f3f08c7265aaf54fbb9b597f90ec4091ee9debcf572a284d91"
    sha256 cellar: :any_skip_relocation, ventura:        "68680805d87b5d4eda798064a5efb3b7f946d3a9a524f624dc10b27633f2068b"
    sha256 cellar: :any_skip_relocation, monterey:       "a0008b6c6f34858792a7cba9fd8f6c5b7ec729f6d286998404365b32e7054abd"
    sha256 cellar: :any_skip_relocation, big_sur:        "41cee7a8320bf4918e35905be19f9b74fe55c0e6313d1cae0dadf5ade13a5268"
    sha256                               x86_64_linux:   "654f775f06113c763499a0a2febb8c5b9709c778da7ca01b42df40311eb7836e"
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