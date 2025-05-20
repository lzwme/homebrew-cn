class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250519.520b587.tar.gz"
  version "20250519"
  sha256 "149bcaec66426ddf9efc0a8294a440fb8a31161bc849105183d8f1fadca71512"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9bd06fdecc0b472e525c4c8bc169aebba692e3e8aa66b59b1c81812d768bb9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d9d05a6c2aa3bd36d8815ac44d474c798f15fae9bbbaac9fd38c27c4f9c5a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5017382dc72abf6a78ade656e3e0fc1a8eb27dd709f7574012947cc440efbf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f776e74bfa8e5a4dcb8fd9e201bdb01368e597446d170947203791e632c9c17"
    sha256 cellar: :any_skip_relocation, ventura:       "3b9e3c031006b1d6f941784a0e6e82052dc4fe5eeecce3de82fb0e9dff260ab9"
    sha256                               arm64_linux:   "42ac33847a3b0951ca96090222d1e60ad0e225d350bce01636e3feee5dc3ac0b"
    sha256                               x86_64_linux:  "5edae1b46b46bc4f1a82c2e3c591a7b933128d3a4c2e1ee4a9e192c17f209e3e"
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