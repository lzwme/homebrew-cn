class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250517.c9070b4.tar.gz"
  version "20250517"
  sha256 "6ca45aa54afcf3330ef9ea13748f3736f987cf840d6eedf419a8a0f123b94447"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "294af6adf898c116024d3a01c426983ba991e67e0a1815a31e40f24fbc287cfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e194369feab00d47a21db6782e33732a35fcad1cd4e05006532cb5f6101be4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48c1340d93c202adf05ff9bafcd62217320bd0e8fdc9bacdd9898972e5a6147c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba62fe107da53e6ddadf08268cdd4ea9fd9e1ac9759707ad0856cfb8b5b05609"
    sha256 cellar: :any_skip_relocation, ventura:       "47931cc445a28604ac74e077e7c2d5f5a18739498c17e4dbd65d44e58a8b473e"
    sha256                               arm64_linux:   "ad321ae9427010258b3000f3efed09969963f45200c80e0e69cf6e373565230b"
    sha256                               x86_64_linux:  "a4477f8a21a492a32133a9639d40a6b4d3d4f5a6bbfd186acd125885f21703a1"
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