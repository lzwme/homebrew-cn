class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230714.a95796e.tar.gz"
  version "20230714"
  sha256 "03181b19990dc42dca2d562799416db033f2b54ed64a6cc45685771eccd01f1a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6089f3b0644f24dd7745846ce1a3132c3ebe46875b645642be401155ca77f13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba8bb898481e178fd1a75003cf210fda2d3466a1055804626a8babb829be468"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ab3f18534c8d32821314ec9eaf3f25de596c5c944480351e1f5362123bbae64"
    sha256 cellar: :any_skip_relocation, ventura:        "395c8586daf7bb4e8796dcfffb73fde7f36f42119bb2d6e6fb6d9e4b8085b370"
    sha256 cellar: :any_skip_relocation, monterey:       "4bf353993d85a45694302b6ff32257622e62bc3a9108e2c8e68ce9e0f87d88de"
    sha256 cellar: :any_skip_relocation, big_sur:        "f65d198fae990e575f0bc3247741ccfe40fd6fabb8233f26e0c57e9ff1dd66df"
    sha256                               x86_64_linux:   "0e393d379ba04e6bfb6b8bda13fe09d010eb1549dba58f1042e8c2cff8357cfc"
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