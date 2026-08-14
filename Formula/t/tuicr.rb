class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://ghfast.top/https://github.com/agavra/tuicr/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "65ee649f46d42ad0aafb94eb618fdb98d6555e979495cff45a34f37531747c52"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cd7d726d31d2d111f9db3f1834a3274cd745b4115b37e8236411eabccf544422"
    sha256 cellar: :any, arm64_sequoia: "e16c5de6edb2718df29884dd2484678b402aee31758ed4ed8bbb21fb368041cc"
    sha256 cellar: :any, arm64_sonoma:  "59d8368ffe09b85beb71e13ed41693aa3f0b18b2be407b786b648d4d1ec4c9bb"
    sha256 cellar: :any, sonoma:        "b47470105f6ca4e31940ffcc2a85d5e77907bebdd396e9b698d823fcd48b7fd1"
    sha256 cellar: :any, arm64_linux:   "dd1336a3c039cdcd5ff7759e235ff9a58883f672a5fe0a5b2281a0dff4246b45"
    sha256 cellar: :any, x86_64_linux:  "fe010f7819e59979cc4d1094116f1b79ecf2a6c79a193c2bd01b8f241b923412"
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