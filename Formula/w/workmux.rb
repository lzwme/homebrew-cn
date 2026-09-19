class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.263.tar.gz"
  sha256 "9b86c529ffe740bd32dc00ff150562545169200140d364c0a134ddb16ce05e13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ad288038f3e4c93545fc8f50227be3329a767ca5777511b84abdf6ce25cf30d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85a8fa705930c2e8c2afa5aceb7918b30fbd4d12e9c7c302bc8977da9c23476e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f6eb19e57995c8a6953ebc0e737848c2b07a0b0250582a9246f5416e2493470"
    sha256 cellar: :any,                 arm64_linux:       "8231e46173a82383a176959ad25473bfe1e2cdf0a875213d3027073884331bb4"
    sha256 cellar: :any,                 x86_64_linux:      "144fb44082d804e2dd7a2a69473d4daf61aa2d16f7f3550abae2c37fd56f8a1b"
  end

  depends_on "rust" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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