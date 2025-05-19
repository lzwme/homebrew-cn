class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250518.e374a5a.tar.gz"
  version "20250518"
  sha256 "e2b7149863d016ff8dd67e3b57c58a14851a3f6bbe117c012ccfea42bba80906"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24442afd5a93774beaf531297578e53f2160878f1c14d304197073b13e27c826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa9f86e43fde19c1ff2c313b0f0bc5a3cd350b1347dde8244ec6b40590be736e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "826e20281d13c0124a5dc89c1b079559c40e1fecf56e23be932d31dc0850bd31"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3be9319e9552e68d3caa3a6bdee9e3cf41ff8fdc50a1a7df1dbe3593609abc3"
    sha256 cellar: :any_skip_relocation, ventura:       "d7c4cd5bc4b8c30b1684f59452af27189564555486612853711a878e11d66c5e"
    sha256                               arm64_linux:   "c88cdc0355f70384ae2240ff4637c042c7f96cb68072d25c805494602c8556b9"
    sha256                               x86_64_linux:  "43f23f55cf8097e06a5fc5215cb7cc2bf31607b6071d144c8d3476e9c58c8e67"
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