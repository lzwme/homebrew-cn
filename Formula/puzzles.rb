class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230616.5fb94c9.tar.gz"
  version "20230616"
  sha256 "f157880e7edb5672a5a57c13cec11563f7559c60c0e2ac1d9c04085677c0fedf"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7095f83f353131268abc18658038e8e57507efda5cb65b48726a025e547491bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2a2b24dc27e645bd97790f71115cf13b664002bf7406bd842a01b887c126e79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b353db64d6fdd70af03571a6318983a176f96d95c96c1d63fb7994c468f997b9"
    sha256 cellar: :any_skip_relocation, ventura:        "3409cadeda01487f4639755fbe03163159109785c693139eb993a93c41c204d5"
    sha256 cellar: :any_skip_relocation, monterey:       "8201d2c8e9be071825e69a673d1e12360417f970ec1b87f36f70922c5d7b7b58"
    sha256 cellar: :any_skip_relocation, big_sur:        "a660e811383c918aa7e1165115b703f95b73479231d12e58b46a542b09542ede"
    sha256                               x86_64_linux:   "87d032dc55eb966bf3e708397cba5a56d0f8b17134df9499b8978c045bd66430"
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