class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230425.bbbbc8b.tar.gz"
  version "20230425"
  sha256 "b190ab218a4d8abdc6366f5d821bb83e8c5b62731430cd55790a07062125368b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca773aa8b2e24df5566be4123eee805a162f87470c2ebbd4c7384951cc811064"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff05912e9083951804581d4ba3cb21084c6c736eefe7c7b36fd5702f25017dd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e0ae564eba994923642b9fc366dd13a2a947e685ca174a9b86802789b7ac6c5"
    sha256 cellar: :any_skip_relocation, ventura:        "3291ac53dd2952d360c8d6bf21cd0b3703764d5bf95e9e6eb589276b0640c018"
    sha256 cellar: :any_skip_relocation, monterey:       "a2345cd813f3b719146dbd3313dfb348a1dac9c2d1bba71e33d657fac74dc24e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce0348d8ec3dd945734ea42a4be418ed4e0a69a7cd478de95aa74e6a447ec472"
    sha256                               x86_64_linux:   "8b04cd82f2b239df127aa7f921537591eedbd78c3cd8ef93429036931b809b15"
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