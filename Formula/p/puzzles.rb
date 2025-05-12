class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250510.50985e9.tar.gz"
  version "20250510"
  sha256 "c402a196133e0d1c9fc082a831c016f189f7446baf830d533378337df5ec3f44"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a94a28cf9dc9ca7cbec1ab74808672981c2c40dd21b89ecdd19cf2d00260bdd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "515e083fa1d0fcb584f74dec74cd784e31ae92523c10903fe181ccab4a7d8a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be40088d9554a8121bd0555a7d1df3a18669487ef52f2d0a8ef2ac9d05204271"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ad5e173488807df99da725c322be233be554ec44ce8e73ccfdb87242098a41f"
    sha256 cellar: :any_skip_relocation, ventura:       "00e496f4dddaa3f020d475333f7f70aea9fccbbf2de220b81ff03e467a40daf6"
    sha256                               arm64_linux:   "530cf2016d72dd8892aac43b83aa3e2bbd8a846e6cb4eaf1ee507625beda518e"
    sha256                               x86_64_linux:  "5d9cbc52dbfa1f6c465cd4426ea18d454f4349b6c2069d6936868fa7ea9af803"
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