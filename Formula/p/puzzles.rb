class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250730.a7c7826.tar.gz"
  version "20250730"
  sha256 "a069341ce5ea5cdc445568b14baae9b441746d9608909789cd884bdd34958627"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3218730e495b4b44577e91fb3a072f4cd9f3d46264a2f775a0fa6c2b4cc443f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d585224f62bdf745e3c25debca3a9a33de4d9e56cd83687b6f2dfc1fd1a7a81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f97856122ee6e461329513f2e20d33f3d0022ac6aea28974810cc33f870d612b"
    sha256 cellar: :any_skip_relocation, sonoma:        "293008e4d71fa43f539a28e2a15ccdf17944af7a1e0b18d7fcc33643c7709ace"
    sha256 cellar: :any_skip_relocation, ventura:       "3a4f02bdb6bece7c9844c4c495198438b7b794b0f7752019c4dfe53941ffa8f3"
    sha256                               arm64_linux:   "4566ea74859bb3c3c5732e0c068a9a79687043d0d03949397dc19cc44dc2274c"
    sha256                               x86_64_linux:  "54b98f09ed3fd981785b61e987c470e26bb890aefa13d2458ca81f31b05910e3"
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