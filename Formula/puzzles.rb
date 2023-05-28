class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230527.b6c842a.tar.gz"
  version "20230527"
  sha256 "5b3723f73c181f18c39373bd66dd75eee7930a3da89afd3e60a29baad5620ee1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fcf9ffff7dd7126ded4bab6e76767e4b6f97d85b8edc319054e9defd828dcb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1070531d3bebb30078e6c6ef6268360bc435c186614696982266085d341fe7ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca8cc18580c34de05a2709943373bafb0d33bca6780218ee8f474b444a57fcd8"
    sha256 cellar: :any_skip_relocation, ventura:        "5189d0c155b836fb6b3ddd798e9a78fdd631f250eecdd343be6d5490d4d4c412"
    sha256 cellar: :any_skip_relocation, monterey:       "210908f0cde89b55472778f576455ba43b437036c309c4881fd9aaafbfaed2f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a896f8bfeb0a0cfbe1e6c351ba44b6febafb5b3ab12a773207cd5fed9b45b10"
    sha256                               x86_64_linux:   "7b5b1bee125a8b940e5075446e8a35d40f6d89628fe2898fc1cef955714a06d5"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

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