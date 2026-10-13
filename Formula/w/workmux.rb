class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.275.tar.gz"
  sha256 "c1965a820e9a3124fc90a25643ee3b4990e8282b8545807aee8595618ca70647"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd8aa5f766c3da0354c9a5e1762043b015d183cd93d249cd0568f37c3af68ffd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1fdf0c3db7b34a61e31fe10da1e566ed2805c071323dbead8b7f27d5a5070094"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f99dd7fde053dcb3fdfbcbe82a247131508e17cd5b1a5de03e9839587da7a63"
    sha256 cellar: :any,                 arm64_linux:       "ad0b93f065c3c74d0d80984eca79d9092d2f1d6a00f538ecf38991746654e643"
    sha256 cellar: :any,                 x86_64_linux:      "54de025f9bef259e59ea44ccf01f42b5b0e33eef346a5de339f3e446663b3758"
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