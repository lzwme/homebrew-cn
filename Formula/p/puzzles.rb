class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230822.56781e6.tar.gz"
  version "20230822"
  sha256 "461c9fb58742a2dce5ab2c7c3df1bc367fc8717ceb80464608dfd6afb8b74fee"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eebde3dc3c2696a46c72d8ab9ec1a15f5a098591ceb246cda35194857263b7c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56cf532782719b787aa9e78c0a3658f6cdc251d96908458ce719bb87495cb62a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfb4e1107160542dd3c6cb31f55aa299b5ee1ea20bfa1225b48206415813123d"
    sha256 cellar: :any_skip_relocation, ventura:        "4e2fdb8d61bcd600710328f541a814ce02160ba94d2d9de70886281e1d2f4489"
    sha256 cellar: :any_skip_relocation, monterey:       "32016697a0ed31d4ba32114deee96fbf3b219c94b5835dd141256e44a7281598"
    sha256 cellar: :any_skip_relocation, big_sur:        "47f9b1012caedb6d512907eaa84512a687fb5f7e8a1545dd9d0abf286635d670"
    sha256                               x86_64_linux:   "7830ae047338e2e7d8df7fbeff93cdcecc07e591f9c5e247fe0ab145a085b39b"
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