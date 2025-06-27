class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250626.fce4fcb.tar.gz"
  version "20250626"
  sha256 "615672a83c00dc5cab4c8bc528e494264c88608e1af1f6d47e95f4016e26f8cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497672e2a4f285614c1957a1abdc610e957f4369844427a68cec0d0050d92076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cea34f1622716decb258d617aede828744afd598ec1bea59adb680f881f6d14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dd7bc564281aed12263e256f6f79aa6d87671aed101869adff716a9e0c37de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd492b41562a8a44c80f7637c90446a563ed850ae9f39d48917b9c11c4323901"
    sha256 cellar: :any_skip_relocation, ventura:       "df8ae960c2a5053208b68b0a07c7d425a66d4142f1166753aea22cfd6cc95788"
    sha256                               arm64_linux:   "d8afc1aba61786d05ee57fc4edb9e085b97df8e2c55fa4b96282eb192d6b2ebd"
    sha256                               x86_64_linux:  "ec581c16eb0c6613197ed28f6523e0e1b5e317e52868ee9ebab5fa1a8e62cbec"
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