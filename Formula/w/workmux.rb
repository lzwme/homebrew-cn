class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.271.tar.gz"
  sha256 "3c721b5d5a80e1f076aae262c2754472c6de7c048df3742bd5f8c946d4c76796"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccb4816b26acab88297c3baa094b7857262d6fa71fd08a00870680dccb20ad15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1506ad7393bff53f710bdeffc0bd57b900876e2a75c88f9979d4bd9c014a116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07d429595e6a76827bfba48e348b33923de9a08f687e7cf29933716840b022af"
    sha256 cellar: :any,                 arm64_linux:       "9c03b61ce2f8a9031336a2150d09c285f1c9c0e39f67a295d2851972d80217a1"
    sha256 cellar: :any,                 x86_64_linux:      "63f04e8ad0c915a531d1eca2dcf2a499431d74cb6d1408a096375821e003a399"
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