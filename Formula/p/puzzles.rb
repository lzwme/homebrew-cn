class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20241108.8e83f39.tar.gz"
  version "20241108"
  sha256 "5adb37653787073a5408833ec9d5f5e2371b30c3165c9008b6674a0c76e78da4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80b6dfe9b52cf3a57fbdfa0452c1eb46a86c1f076f0a74a5e57bceef66e03ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77c3094a3d347edfecf743227ac380de7372377681e78103889f23e5b5f8bea4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89f27b10bc74236b5d8aa29afddb3f9e9a64e218ef09bae740d8a427e3049a52"
    sha256 cellar: :any_skip_relocation, sonoma:        "32d508d84142ab5ee895216e8719076c4df502f83a7d4c08a3e6591194f74787"
    sha256 cellar: :any_skip_relocation, ventura:       "4a3aa83063f9b0c66aa58447b4d2a393fb5eed0c00c71a182ec2ced688122ad8"
    sha256                               x86_64_linux:  "bc7428f46577f3ca422bc29a09345fe2c30441e38117ebe2551bd8426c219cfe"
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