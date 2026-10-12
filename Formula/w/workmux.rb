class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.273.tar.gz"
  sha256 "cbac0eedcd3d9f21a172a9b9f3a6f93f0f104ec4bfdcbdf14f7d00ce65280b0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b22b30bc4f8e3d731ab16767ebcde4680d68428c535be05ab9a573d86ef6f01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a44a5ef6bd0366521ce6f882502e1836cfbad2b07ee416348251aedc0f37d05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0e70ae1849b527d1dfc5313daf3e736fba8f69d87911364f020d3e200199fae"
    sha256 cellar: :any,                 arm64_linux:       "bd09d03c1ed3a1d175701baa5bb8145270ed27135b41661a70c6f50ae4be25a5"
    sha256 cellar: :any,                 x86_64_linux:      "81eb9ae226a9b743b1096b93852331459d170f876becf32acdf299c93bd34982"
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