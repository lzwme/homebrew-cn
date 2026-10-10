class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.272.tar.gz"
  sha256 "c669811ef75470f43c048b4e87607b869624cf18b61f4f0f65ba2c2ece079b29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae711c2130ccd32cf106677fff9a9c8513d6f16c0ef28fdedf4c8c8e0addbf94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f0fd336f07013c6bd6799e9ef8a7215b090fa2cdfc9560c935f98b7d213837d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4dd4016fa2ceab25f2c14eb00e669e3e0404f235892f93dce520aa93072725ee"
    sha256 cellar: :any,                 arm64_linux:       "2d8ba38627510c962790f13a423d981a5e924b61879e013ea9afb704782e81e0"
    sha256 cellar: :any,                 x86_64_linux:      "30c8b0e25b91db25705773b72c18e99cff306660e40e0faba73edd91b24619c8"
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