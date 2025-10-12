class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20251011.d928126.tar.gz"
  version "20251011"
  sha256 "fc86b3779be8c8d468733ebca882efe4da32b597a12855f8d1adafafeed82aa1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e295b19709bcb798f8ad8b3065c44bef14784ca2fb62b3f1c1bca1ff04b218e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e9d7988daaba17b1587462d2d599ece6a07a116def8a0a05795d6a04fd73aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d19c445cb2465bf88849aae241870d673ac9e204039fcb8cc74bf128e01b0c54"
    sha256 cellar: :any_skip_relocation, sonoma:        "457cd68f95d87aa668248d7e1b79f11138eff26ee418fdd77ef644f1e58209ea"
    sha256                               arm64_linux:   "2ee2ffa85c5233c222848087b0c8a1cc570895e2fc347c0266ea8cc4a3479bc7"
    sha256                               x86_64_linux:  "4e584c96c65d251dfd8f2762613898f36bd04df9ac66ab55510b57d8d69c22de"
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