class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://ghfast.top/https://github.com/agavra/tuicr/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "212bca12bdb5a089b1625c53c8288dc6f9ddf043559f77757a564617c8f834f1"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2533e07287786e56c3d72cdd061699edbecc3ad0354b6de5821c9a0ec0b4a382"
    sha256 cellar: :any, arm64_sequoia: "d5228c83ecc1c031b106e213c1939e2856365568d6f2811dfa0fd92613b92c93"
    sha256 cellar: :any, arm64_sonoma:  "449ecbe5589ac9768bf799d6546e4d5c98bcc957a0ebda9e064b6a942ce27ae3"
    sha256 cellar: :any, sonoma:        "33ab3552bac60436b5f5808b8b81f466841d6e1d7fa523f180f9f056f23afe23"
    sha256 cellar: :any, arm64_linux:   "5312a614f4b7bf09381e7011e16441e2927cbd7ef45b35bdd1e48e679de4effd"
    sha256 cellar: :any, x86_64_linux:  "000f2215a06e351021551a77d1b154365b7ebd5bae73102ce7a32eda355c677d"
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