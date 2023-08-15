class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230814.a409cfe.tar.gz"
  version "20230814"
  sha256 "f7517f16abb4afd4862c98759231e8a12fc3110c9e8d182dbee3651bd5c5d1a9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9014b784c4d9d914a353fc30800adb9c310ea6ed1951083bcbc09b942062c70d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6d2c5ed07d50e98aa1e716c16e0e68aab94eb3f0551051b8af509b2929b048d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b1d9ac56cda32fa2f7b305e265ed36bf58187fa7a659722444167fa9e71c20b"
    sha256 cellar: :any_skip_relocation, ventura:        "161379a153517be3120c12b17cc9eb44f3ca73a547a0c4e29da08446f8a167de"
    sha256 cellar: :any_skip_relocation, monterey:       "eb4bf9f005a8ee8c0800bd7231721de9ce02030099d80ba8c71fabfc8acc0b6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f24c1d8dc7c388aadc393c21a5fb23be5b4d2764525ca05250ab6931f8e4f92"
    sha256                               x86_64_linux:   "d7ba6128ac1445c48df5b57b81d6cd55ccb81b3d2b1822fbf27b478fd6641d67"
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