class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230421.20606f0.tar.gz"
  version "20230421"
  sha256 "502e22b6d20852a1c39ee515d085bfa14463c6d5956c4c9b73a8d37138e884dc"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18fdc99fd7242452068e4f6c1f35fe9480afe32cfeb0b4eea8a42c2b3cc575e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f9e0617907695d9da6344c2b0a66823f30dca6e394c3ce1472bae5a72ccd320"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5cf4a1c73f9f4234bfd006053f756ab203110d2e51014fdfbbd52ecb8226b1d"
    sha256 cellar: :any_skip_relocation, ventura:        "2b3efa5fe1e7d0aa9529b7038b7cc5c8e5ba7b908b2ec2f6fa7ae068f435e04a"
    sha256 cellar: :any_skip_relocation, monterey:       "6abbfe6b0883ae1f01cd8f9fa35360425878d098ba6660baa4f4b98f26f1b60d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e07413900db704238f69dc496112bea37ac0fc67b6aae0b637a7e5acfabf3455"
    sha256                               x86_64_linux:   "87ba3dbd8456592d639af9075b2a8b83da1f2f45f62949671c1bc85ed7376d49"
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