class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230626.c5076be.tar.gz"
  version "20230626"
  sha256 "e97e9a28e71bd83f89f2df6deae3d47c1c79c19b68ad812698101e706d3a76c3"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6af4dd5bae240fef9d15471c5c1db775c2d103bd876c0ee940b9f9496ea19a41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e9d01e70491b5bc7d5e3e418b66402096a3ae336b7f657e9311126c64881be2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c5d1764b56dfedde788d3dde2adebeda91bfdf86819a5050bd0a5a1db8ff1f3"
    sha256 cellar: :any_skip_relocation, ventura:        "4fe4e1a5db63bd290cdcf17f7af98fec4610056a5452c8935035035d2b737e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "4bcd95f8fce2fbf25a04fe1691823469f8e194c1897c4967400d2ed0266a257a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0ecf38a1f6fa5802f03e4019de031b88343fcb53c55799cdf45e264ee7e88f2"
    sha256                               x86_64_linux:   "c3739688a515f1191d0cb921e43b6b4ee615771198aba454bd097fba16ecd011"
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