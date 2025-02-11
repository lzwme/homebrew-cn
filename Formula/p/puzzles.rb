class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250208.5edcabb.tar.gz"
  version "20250208"
  sha256 "f0912f296b71c9f998559878d560de60ae65a5a6f904ef7cd5f277237f5596ee"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac8e0c292c5026473b08d96e3f7a936d0a58311054470a7a37a07f5af83e3f03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1535f3d7e7adf79358a327e499dad6b11a1aeb452cc8fdb7fc0412d4d68ae748"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e461c75b8b50dc10ec3c1675913f6dbf4e2ab90bf9ebd66a80a34ed0b3fb734"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a6c480057c051f60d19cbc7688139e72bfbff212c648de223b1c76f73a30930"
    sha256 cellar: :any_skip_relocation, ventura:       "64cca4f51868e216fd89b630ab3fbafb458dbdefd64ada5b03a6b37bd656d273"
    sha256                               x86_64_linux:  "052f7cd2b4cc5262ac6a2551868cfde5af4715b6a7df021c19e33ad0f82f46c7"
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