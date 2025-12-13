class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20251211.5c2f87c.tar.gz"
  sha256 "40b63a8114ac286b5e938ea9e971a6ebe0f3d83fd0e3845260585ea6a9fa25b8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d520d0d680f94bcf789667de9eabb6464228f82f3da7282df7328e88e3484f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf9f7469689f7c69b07994147c4485be6d36eb42a78aee181fc1f8a84283830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6060356eafef792ac5fbc0e0690804c69c58e81f0fb5cc9ba3b70b4a6bbb60f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed2ad87f23940483aef258a4791d0cfb15bbd34eab08c00c569b7f1462d09780"
    sha256                               arm64_linux:   "9280f0ffcb4e639ce52c381291a32f81e9e3caa3de622bf7d04d4b33ccaeb25e"
    sha256                               x86_64_linux:  "2b187dd65e2b883db757ef626e2388df87183b7ba120caab8954968792e1a9ab"
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