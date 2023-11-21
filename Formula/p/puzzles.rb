class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20231119.cb8dcc3.tar.gz"
  version "20231119"
  sha256 "49726773b248d8e0b6219d42de316ff6b69cb6a2a484fd6d080bc64ce0f98ba6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9836acc14a8dcdf3f6add2e9b4b8d711f1851a9a03533f51fdb18ac9e285650"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eacb39b86abf0192ec722f1c520b26e4bddc2db00014c594bfcc590ff386fbdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee243c7c79f72361dfab3fc77b603181565271ebe2627aa32a0924a7fc9ec1a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c410e6141d2a5352edb078847fbc4c19d4f03420703105f676a90cc2a2fdfc9d"
    sha256 cellar: :any_skip_relocation, ventura:        "678e6f6c95eb6f4d9b05d01e26ceddb24b067db92965ac1364f93113a033044d"
    sha256 cellar: :any_skip_relocation, monterey:       "33373ca2f39273a174c1d8671bdee9f580b698056f33439edecc195cb2492f82"
    sha256                               x86_64_linux:   "a819ff519e516e2fb98f54134ef2da3845259aec4d80e4ed83ae0a8b079b8fb9"
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