class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230402.0bd1a80.tar.gz"
  version "20230402"
  sha256 "6899b8f3c9d26029113bf5482cc7712d298a4758b4b2d899ad9a75229a5ad5bb"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cac384f7e86ca10240eb47bda99639b000bc382fa35b55bfc81f10541787025"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b028295f460ef526d138ac5b2ab118208a68995c11259f24a1902701796ab944"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "571d8aad6ce56f935104fc4e9f3cb9a69cb890203f3aef628666159594c5b1b0"
    sha256 cellar: :any_skip_relocation, ventura:        "870516cd18d0b4bdc158540061ab55ab76a87811f2349e254f25e511ae149959"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d617a84454d33580ba09c5a90cdddf43857d03a5981c3396e41bb15ee0a25c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b716a5443e09142b0cf2c5d4dacfbc5a9c9e7c719418855dcdb5bd6f2fc6488"
    sha256                               x86_64_linux:   "6f846b9213cb422ccec21aed7471b1ccb181015171ef3102997a94b41f699561"
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