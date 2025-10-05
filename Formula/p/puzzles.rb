class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250926.e00cb46.tar.gz"
  version "20250926"
  sha256 "0ac32b858a5a4d1333dfae24b796ff6c263aecf0a86304b9d05c70f268b64026"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12a4d49a7e9090e18805cf6546998a579254625b29ebb3ed8d8a34795d2c3cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6796f9d9bd257477938f7dc38d77faa4cfa1e726e503ab079d2fb94904d4c7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "093c290c5e4ab9d3917672d8201943c11994aa1203b1b468db651ff150578940"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f16272cc63cb665273e838bb2b564dfd9c123cc703546376f18fedf77669eff"
    sha256                               arm64_linux:   "8b846ff86a573e1668df29ea97a7e2fa561e3ae7f09534e64a1d77f282bba43d"
    sha256                               x86_64_linux:  "cbf329c08d830af803324a5020eb69e6763d8d94255367fdd6d08a1eb08db7fe"
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