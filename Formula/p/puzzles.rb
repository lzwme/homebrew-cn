class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260906.38e7ea3.tar.gz"
  version "20260906.38e7ea3"
  sha256 "87329d9782a1b206709118708d5f64200f9db4b81dc608ff733180d9d4bfa47f"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8}(?:\.\h{7}+)?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a61ab138e6e38d798dd86b874c57094afb74de18c99c6eb0b37e2d2d0253c33e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e5925e90c4af21413be0137984dd514d431286fa5ab661ea2b16122dbf3d560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53522b9dbc0207c9dd7f4af34cf293a2eccfe2f00737cb259022c81f2695a573"
    sha256                               arm64_linux:   "d324e19e257b69b533f37a6fd6fa8bdbd34ff3a01875a039227b139ac6426142"
    sha256                               x86_64_linux:  "2ac4c2a80725e1005231f4d0416724112959dfca989d6daa3bd9587a25fb4086"
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
    # Disable universal binaries
    inreplace "cmake/platforms/osx.cmake", "set(CMAKE_OSX_ARCHITECTURES arm64 x86_64)", "" if OS.mac?

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