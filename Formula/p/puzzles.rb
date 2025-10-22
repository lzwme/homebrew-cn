class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20251021.790f585.tar.gz"
  version "20251021"
  sha256 "e0466016cc0fd28aa34b43996e4c931c2b3b74a9b63e050aa6c256b2c400bd0e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9a14afd110449bd40e0e2a528405f4f7e254f2e2e32f2ca44eca743b1c01c18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b45821caa7a9d19b66db48756ccad981800e5ff74f5a0432525eeb4c937dae3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9785985ba28d9c26e0ca522e3c61cc0937ed177891fcbe0f683ee9a77681078e"
    sha256 cellar: :any_skip_relocation, sonoma:        "447cabf0403a6031857148de5fe7e45c30eabc61bc1ff58c1e50b337d415deeb"
    sha256                               arm64_linux:   "592360f21ab723e3c84c67f58e8c5d527015e4495f953bdb0112afe5e16c937c"
    sha256                               x86_64_linux:  "698d365a00234a6266fe3d1d719335a79412c8178b58a0c6e6e8fdc5c8fa01ba"
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