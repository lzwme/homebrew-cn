class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://ghfast.top/https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.12.tar.gz"
  sha256 "00dcf0d4e4ebcac777a633a862299d4f3c431c49ccb262211cb079ad273c37db"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd0ad946e09a506e30c423f062fe61804e6bdbbce8765169e0f72fb097a9c3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50682400a81c2a8291e94b5f5e6aa0b615b6c38aa424eef94a38d49be5b74903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ff54303aa034718d909c25f4415b97e316395c80adc74bcd6cb0c7da0c23042"
    sha256 cellar: :any_skip_relocation, sonoma:        "b39dc4966dba810b9fed3e0bb6ed291b4de84a935f6b48e43e4bd7104b8b55b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39e9b4976b98f171cb2f0e2439c06639240be494db6968cf2faadd19f4261a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9394b54537a8201a13925abb5b89289b93f1e4c050f9f5b6c20ec26e5bfee1e"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "packaging/man/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
    man1.install "taskwarrior-tui.1"

    bash_completion.install "completions/taskwarrior-tui.bash" => "taskwarrior-tui"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end