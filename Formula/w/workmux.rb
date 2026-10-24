class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.277.tar.gz"
  sha256 "d60acbd09437031e21cfc5edec2302b938d02ecefd8aeef4f162c2720c240107"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d00b67c0c3b1824c9ae949767d10c26a6cd33ece80c15ef0ca380549dc66ce4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cef2f8bbfb36d751e020d8437d1ae4dd2118bd6cb006e1e4b94d77bcf0b60648"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be1de5bf2767af5a81bfb10ea38406872fa52d9ecfa909aa66af4b1767a58aa8"
    sha256 cellar: :any,                 arm64_linux:       "4ec9c7b67c4153624f722b6cb1c032d44049a6115d644c785bf05854f057553b"
    sha256 cellar: :any,                 x86_64_linux:      "1d953e9b832a7b84780a35e60bddfac616a57b87dfd30fee2feb1e984b51bd44"
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