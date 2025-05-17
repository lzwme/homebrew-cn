class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250516.6d09ad2.tar.gz"
  version "20250516"
  sha256 "b787c368119fe94e19e894527559146cfc84cc33ba19ca710fc6a7c6257126f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035a0eb953c8b8e581ae2794bde5023a403f35ebbeefebd6d68e5042389f2c6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78366a5576302510ceace917c1e7a66acef3f21b8f2ae74aaace5a02b390e9f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7304a76e486da76c8fd42597307cb7be77d4ac14ba043b4fbadc0027402f28e"
    sha256 cellar: :any_skip_relocation, sonoma:        "80db85a650f68cc8776daed6c177cd523a204d77a33fb505b118f03a86181a60"
    sha256 cellar: :any_skip_relocation, ventura:       "9eb6346f269ed6cb5ba97207aa20ffa150fdca298aa8ac8553e9763cf6107226"
    sha256                               arm64_linux:   "728f8eb2bee2252afb32f5067d0422b146c3fd9339e2315c2eeb2358b6c10c79"
    sha256                               x86_64_linux:  "528797896e78f32067e3d66c45c24db72ac7eee00640bb00a11676dc63a27459"
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