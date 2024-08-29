class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240827.52afffa.tar.gz"
  version "20240827"
  sha256 "1be1599ebefe5efbf10e9056c87e03bfc3448d25935c3a153736f33693136cb8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c335db61dc3d7443f6b2bca05179c5840f9082edd02c7f84cfb6a3b8e75e49b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b30af8022287de6a6411261c8e92a49e263e69a934d142acb9838f09fbe7ebf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed11bee4788f18349120eae27344bab20e304a11ba64b78d93f144eada7ec7d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c1cbf7b346a0563f1eb2d2ad231b0a4b1bface918df397278b4d031c29243cd"
    sha256 cellar: :any_skip_relocation, ventura:        "23492f39ddb713052d3a7eb67e6c0bd31c518cd0a56cc6da332959f981df7e56"
    sha256 cellar: :any_skip_relocation, monterey:       "783874c9b54b1dc4098748ecbcde0a1bb69533db2387cf6991e2ceb5d3e7e3b9"
    sha256                               x86_64_linux:   "b3324f61167f02fd0c13acdfeed509c874076ca2133a6592377ca5b8cb200fbf"
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