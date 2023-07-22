class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghproxy.com/https://github.com/jesseduffield/lazygit/archive/v0.39.2.tar.gz"
  sha256 "3f8f6324d6e47e1366c7c4149dafb0c059d3b130e0a2326bd302ba9a61893e2b"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e688ff9180a5c86c5181e0590e67a0a7cef49c5ed6919ce8cea9c105e4ace678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e688ff9180a5c86c5181e0590e67a0a7cef49c5ed6919ce8cea9c105e4ace678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e688ff9180a5c86c5181e0590e67a0a7cef49c5ed6919ce8cea9c105e4ace678"
    sha256 cellar: :any_skip_relocation, ventura:        "6e7e5122c5bf814f03f54242456b23c20ac7817cf8ec69d907f722993bd4aa58"
    sha256 cellar: :any_skip_relocation, monterey:       "6e7e5122c5bf814f03f54242456b23c20ac7817cf8ec69d907f722993bd4aa58"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e7e5122c5bf814f03f54242456b23c20ac7817cf8ec69d907f722993bd4aa58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74eb6d0da88e75c6f59f63f79e1b03370e6b0dd38924c274eec6c1012016f1eb"
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