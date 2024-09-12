class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240911.cd97968.tar.gz"
  version "20240911"
  sha256 "9754037bf3d142768405e9d1dcd712b61b43cc2710d59386cfa442b1eac67e3b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "91038c478dc16d2b60c5efb6453835d458ecd6c843d316047e4dc02f23b34e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32fa88905bd4dc320ba05e54aaf7a9e9eb74ea77e8632b6a7bdec2390beac57c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21eb7093efbbebd8d893aa2aaa5c3f50d649d89f0fad95412072a5eb5a47668e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b440b0adecb5e7373d94a533d099b75ec827cee1288085d6c46f371d93e90560"
    sha256 cellar: :any_skip_relocation, sonoma:         "53961e81dbecdb6213ddf59da15959e3376bd2e4cdae38f946c3345afd734ac3"
    sha256 cellar: :any_skip_relocation, ventura:        "04774cb1351b47175334239be01a028275bc2879c8c08811105ab8d6c5485246"
    sha256 cellar: :any_skip_relocation, monterey:       "74eb99d91a40dc4b1138a5d2b830c85c003298b4aeeeabfe092a3e1cb40670fc"
    sha256                               x86_64_linux:   "42654be60b495ac2b00c79c7e4b8a7769f7e22b6496d498a0e503d1f5a725b63"
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