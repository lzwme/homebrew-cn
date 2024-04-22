class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https:taskwarrior.org"
  url "https:github.comGothenburgBitFactorytaskwarriorreleasesdownloadv3.0.1task-3.0.1.tar.gz"
  sha256 "e36653304c4850e7808bd417309c1e8ef6ce7c44ae8d7e553a076e36c0871655"
  license "MIT"
  head "https:github.comGothenburgBitFactorytaskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sonoma:   "0fc656c2efe41175806e749c3bca717d18abb6fa0f7db829d556abeafcbb7f53"
    sha256                               arm64_ventura:  "b08b3e933a4b179d2b6348349fa0c3b23d7f4a3780c82e47b45966e8fa4032b9"
    sha256                               arm64_monterey: "3f20cb00fc44621770598fe07d603afb74b14170e8b0f9a49bb303e0194d2a06"
    sha256                               sonoma:         "d1a5c71ff8b18d60168fc8f8cb01562394f1a866f2d845d782809e1a9bde49f0"
    sha256                               ventura:        "8eea38909c65727b9c3c371a5556352c83cb57f69615212f6cd945174a783f57"
    sha256                               monterey:       "a6718185479d6a62ea9876ba1ba4986622384f086339445687b5880c1d7f840a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d515ba03922af5e580ecf0b45129a48f4f98f5d4a0940b161d2020a8597c69ce"
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