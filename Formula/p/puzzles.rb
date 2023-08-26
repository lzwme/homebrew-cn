class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230825.f279c5e.tar.gz"
  version "20230825"
  sha256 "9160eb05efe8ca36c41b6f7b1cac9419752d76d7906cb1dd1d6369ead92eef33"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ada0c60b0ed5a3a99445bed3b51e620dfb6eb6d02d60fad477b261b6a10e46a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb8eaa3c7eb640f47585feac58a6b2598c966a2b35a9ad209513a3a74042f74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7de3b93ea31d977c76ccd42e17d2e8270bda6fed28c4b50e83d9b954d3d554a0"
    sha256 cellar: :any_skip_relocation, ventura:        "a85b71111023b444d9c5116b75b63ee1a5da6538d85217c8769f4525c0f0200a"
    sha256 cellar: :any_skip_relocation, monterey:       "523907a8c57a24b55e01d068ccc5079c7fe3fcba5e51e2d79b21da0820052214"
    sha256 cellar: :any_skip_relocation, big_sur:        "0222fd72fdcb7a8f9aca5a14d2f398b018c7612cc708a56f7c86412ddbb0b614"
    sha256                               x86_64_linux:   "b4157bb74298ccc582900729b5a156c002dab881f4d38fc3278b57cf4ba3bd94"
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