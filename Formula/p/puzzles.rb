class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250615.b589c5e.tar.gz"
  version "20250615"
  sha256 "a5ab317bef3b5d0cb6a532352eb938cde92bcb5a602489702c5ee4986c5c78a4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c24a6b8ed91580696c9eb3079e88e0e2bef9bc47ce6c688681c25abadf7f2ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db2b3a4e1fecf6ad6c7fd88958dec3bda176dda9042231f651284c78b292bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c46bb5a4f43c3b8ebcbc0256fe3873d62571272b5a9d64453bee8ffc9da4070d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8227d5cc02a5a110c114aee8b041a0afc941d964a2b5663c829368eddbfc4ab9"
    sha256 cellar: :any_skip_relocation, ventura:       "b3f80d565d5df7dcf1ef58e9aa974e17be564b055b87e7d695fbae2114135f9e"
    sha256                               arm64_linux:   "9306aae07bb3008f400a465d9fc56b262780e32f7bd0c75737bbf73cc5a6b903"
    sha256                               x86_64_linux:  "38e34749de6190a7f35cc1bc494414ee749e6e0f41b7548c0072823c63023cfd"
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