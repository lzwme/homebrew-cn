class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https:taskwarrior.org"
  url "https:github.comGothenburgBitFactorytaskwarriorreleasesdownloadv3.0.0task-3.0.0.tar.gz"
  sha256 "30f397081044f5dc2e5a0ba51609223011a23281cd9947ea718df98d149fcc83"
  license "MIT"
  head "https:github.comGothenburgBitFactorytaskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sonoma:   "6668c7c712c4866eaea4d847dc6ac83d6a4bd27119bb84650112f4a1573ea64c"
    sha256                               arm64_ventura:  "3d1ba07e32cea8ac22d10309a35cda8f7f4a5ea45ce80a9b424911340e3af774"
    sha256                               arm64_monterey: "a0e2a979cfa6e5a36c8efdaef9a2a5c9674949979e315a67b902a85b3860bff4"
    sha256                               sonoma:         "0bc2b60ba53ce471c20131d5be4d0baf4e2cb7215e503a7eaff73eed351b8d01"
    sha256                               ventura:        "e1b4e8cb041e8a21f7146b30d16d16467c308fddda4cb0da2a903520dd847a6b"
    sha256                               monterey:       "b80d0e7b014aa23afecbd7f72a7dcc88691c86a79912b2a9222cfd910ba5fb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f79851192203b44262e6a75607a9dfda0dad521beb1ef2bac5a73b09731fdcd"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "corrosion"
  depends_on "gnutls"

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

  fails_with gcc: "5"

  # upstream bug report, https:github.comGothenburgBitFactorytaskwarriorissues3294
  # and PR comment for the workaround, https:github.comGothenburgBitFactorytaskwarriorpull3302
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches080b833258961c922d85984871a96ca55bbf519btasktask-3.0.0.patch"
    sha256 "362834215f7308f5c2af1b6591d98907d2f77fddc4a341915e0f47eb153724ac"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install "scriptsbashtask.sh"
    zsh_completion.install "scriptszsh_task"
    fish_completion.install "scriptsfishtask.fish"
  end

  test do
    touch testpath".taskrc"
    system "#{bin}task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}task list")
  end
end