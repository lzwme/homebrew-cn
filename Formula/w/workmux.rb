class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.268.tar.gz"
  sha256 "9fbec5ba357662ad3f9c426defad14718e5bdea20aa085ddc52424060802dcde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4f7c8733de7d9d935234f08e93db4bf1cf55f3c09beb8ceaad8eaf2c2505e7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34d1940ae0ea83b0781c75b18fa27ebf552c4e11390abd44e68be39a75ed445e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c68f3251396d96729214ed99bab73840aa6b981053c22c1563f7588958162ba0"
    sha256 cellar: :any,                 arm64_linux:       "07cee987efd903e2a05918fb1bfdc3d2549ea716e626317e16c6caf45d72248e"
    sha256 cellar: :any,                 x86_64_linux:      "884913d89a23c10539be9c880f6ec80454c51be843ae63b46dbf003df4228465"
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