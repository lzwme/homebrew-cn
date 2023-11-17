class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20231115.96d65e8.tar.gz"
  version "20231115"
  sha256 "672e3a4d0636c23458c89da76376b375192b14447398328a418144f8f833034b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dab7a2a93788a2230c4546c0161992eabc25777def29cd7e7a700bbd5e7e8b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0abe2d0c791a1a23bc4e87a4f112719e225da69fa7b148e50ee8a6411831b884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e1940deb94616152e727f161437bf6f10292c03dbdd90e63a091b9e4b8eb27f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d97a13a3bf6dcc9166684976a5a99a38996da42f6706ca9e43371475989a82d8"
    sha256 cellar: :any_skip_relocation, ventura:        "08ed73a6906ae9d99d6f4dbc2be3b56085b24a7957f445f85890bf8833cadf52"
    sha256 cellar: :any_skip_relocation, monterey:       "26dfa3232486639f80a3fd506ade5a1c03a5c73108cebe9d0fe83b91eca45f84"
    sha256                               x86_64_linux:   "e01578122bbaf01cb15908ad2f1713c460a5b5e4d85d4830e620e024d129f811"
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