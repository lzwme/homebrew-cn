class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.267.tar.gz"
  sha256 "987e9adc3cc772a7e5c2eff3d8113ca2017dbbd3c14c02d4601f10e68d11b114"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c709b1f90c25abcb85509fd45abe2ea9dfe59c4096b81e51afb3e3f69094465"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2129735e65b10e0b90f320545f4c545d1d939d492b6e797e3484882a61b683de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6a85807b940d681c67a28b85e9ab09120f324ce73b88e994ee1612bee55def1"
    sha256 cellar: :any,                 arm64_linux:       "77f6454e0d56642420b4ff582aae0ec92abb4f198088b6e1c2709ab18156c15a"
    sha256 cellar: :any,                 x86_64_linux:      "d7e84a6e8d90d743afa7a567774e4a7b0a713486be3ce7d1636ea4c34cdd4fd5"
  end

  depends_on "rust" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"workmux", "completions")
  end

  test do
    socket = testpath/"tmux.sock"
    mkdir testpath/"repo" do
      system "git", "init"
      system "git", "-c", "user.name=brew", "-c", "user.email=brew@test", "commit", "--allow-empty", "-m", "init"
      system "tmux", "-S", socket, "new-session", "-d"
      ENV["TMUX"] = "#{socket},#{shell_output("tmux -S #{socket} display -p '\#{pid}'").chomp},0"

      assert_match "Successfully created worktree and tmux window", shell_output("#{bin}/workmux add brew-test")
      assert_equal (testpath/"repo__worktrees/brew-test").to_s, shell_output("#{bin}/workmux path brew-test").chomp
    ensure
      system "tmux", "-S", socket, "kill-server"
    end
  end
end