class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://ghfast.top/https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.8.tar.gz"
  sha256 "fb75c8c88141d49db25d4bab62f78efdf8087a76ae9d2f0cdd06ec22e2ea7ea0"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "922f3edac9f7e51d34bf6d5b936c452fe8e8b6014c7bc744ce3cf40d43c6c31f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6af4ccf35928a94a53f6b228eba2ac026d470760c68ca261bbea342ed050ac1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df60cd013e15429ed5fd0c0a288837d5dd84fba18200c2fd1bab8726853a8406"
    sha256 cellar: :any_skip_relocation, sonoma:        "37cbdf37659e5e6452d71250cdc3d4c0eabc6324fdac42fc6472c2c7b3a1b8be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a73bd395ec16f2c0525121bcd452fa1c13835e92406c8565e1fd190bd6dd7e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "545186dd217aaab82d8cdd42b9cb56a358f2ce83943fa79a04be8d7aa5d68310"
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