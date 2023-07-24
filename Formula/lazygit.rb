class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghproxy.com/https://github.com/jesseduffield/lazygit/archive/v0.39.3.tar.gz"
  sha256 "32231f7654339b197dcfe564b9edea7d9fa623bf6b41cb9ff17002c6a1307808"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b5e1c9ff8db13a2c6d2f75c9c506ff88616c8a7e58a18d66ab9442cb5563c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b5e1c9ff8db13a2c6d2f75c9c506ff88616c8a7e58a18d66ab9442cb5563c33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b5e1c9ff8db13a2c6d2f75c9c506ff88616c8a7e58a18d66ab9442cb5563c33"
    sha256 cellar: :any_skip_relocation, ventura:        "2af561832671b9aa7f0fe91f3746cba2a8349fb4bf576a82db7ec7e9a5891daf"
    sha256 cellar: :any_skip_relocation, monterey:       "2af561832671b9aa7f0fe91f3746cba2a8349fb4bf576a82db7ec7e9a5891daf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2af561832671b9aa7f0fe91f3746cba2a8349fb4bf576a82db7ec7e9a5891daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d2fd42afda4d264d1a49953a53373d480e6bde11ef92a29cb56bd08046ce3da"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' to do certain tasks
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_DAEMON_KIND"] = "2" # cherry pick commit
    ENV["LAZYGIT_DAEMON_INSTRUCTION"] = "{\"Todo\":\"pick 401a0c3\"}"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "pick 401a0c3", (testpath/"git-rebase-todo").read
  end
end