class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250216.b99f107.tar.gz"
  version "20250216"
  sha256 "4c4ad4e3cdaaae93c55aafffe51b8222997a4691d4f8c75c911a25483012fb19"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7833735dbecc65d35311226a5ee83b9957b1fb859df29f1a4900bf63a2a6cac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73aaab29076d60cf1ba31ae741ecb91becfb28340b24b00b7ddd3eac467ec77e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "317b2e487fc7835b730486b24fd03de74ab39b661dc7c74a5dd438360880b0b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e99c5b136d4783873a1eb9713aa6709e2a41ededcc4346e6e94969063ed714b"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a8534363e082f54a605de502cc21eac03af47b8e997c39d5a9263f8af7cef8"
    sha256                               x86_64_linux:  "ec344226951e768ca7488b1b468467b30c4611d132f52aa574fab65cdd64a59d"
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