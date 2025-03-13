class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https:taskwarrior.org"
  url "https:github.comGothenburgBitFactorytaskwarriorreleasesdownloadv3.4.0task-3.4.0.tar.gz"
  sha256 "8a4b1a062ff656e31c8abf842da9f1bfe8189102ce9240bf730e92378d52ecc2"
  license "MIT"
  head "https:github.comGothenburgBitFactorytaskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "a89d423ee764f4d612b94edc61920bf7745c41b7d34fe85c077450934c097ba9"
    sha256                               arm64_sonoma:  "1302e7fcb695fca0eaca9f6ba18f4e4674eb57596f8d544b7f535673c625472e"
    sha256                               arm64_ventura: "50062f1153caa66b43833c65177c97e1e0362e19ec343896b616a1fc54e340e1"
    sha256                               sonoma:        "9762be06acb586f27e6c4001865297b75ecb19ea4e553fd03fafbd4e6911f4f1"
    sha256                               ventura:       "af992a0f16d61dc04a0ad2b00118f647436ccee2bd8901f2b58d24bd2348c81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07bf2d32012a31ee0f7231f5bbdb070a833845671a18ee80ac4b12890817d655"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

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
    system bin"task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}task list")
  end
end