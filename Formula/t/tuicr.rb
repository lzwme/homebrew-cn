class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://ghfast.top/https://github.com/agavra/tuicr/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "adce72de532ba0743e373b703590a6bc098bf49efbab21257603c19be8161e88"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "575873d9e58a520ec99533513ce1203abbd5056fba37dfd6bd19a78ab3875191"
    sha256 cellar: :any, arm64_sequoia: "472835c617f3ac0f07c823f38d80d65b74af1232b0835f09e01263d1984bb312"
    sha256 cellar: :any, arm64_sonoma:  "57fde010a1a326e1fbc96e9e3b3612ba7518d54404b123896b88966c9d6882f0"
    sha256 cellar: :any, sonoma:        "744bc73eee123fd3184256d279b4429fe35b6720defdb094e81f2f8c34f2ad5a"
    sha256 cellar: :any, arm64_linux:   "037dd7daa1ae24318ebd81cd49ade736d74103767418c5a91120083f423f64c4"
    sha256 cellar: :any, x86_64_linux:  "162508d2a861debb96e6435adb36c2c2699f18a9551f5d04d608961c7085f271"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "test"
    system "git", "config", "user.email", "test@example.com"
    (testpath/"test.txt").write("hello world\n")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"

    assert_equal "[]\n", shell_output("#{bin}/tuicr review list --all")
  end
end