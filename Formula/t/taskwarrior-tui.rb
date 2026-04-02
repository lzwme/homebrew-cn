class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://ghfast.top/https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.9.tar.gz"
  sha256 "47c49ff0037b70da46f70191aa9fca3d78bf2307e69849e186265dfba440b72c"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f0ea004aa4225b4b21c3e9210b8b54babd893db7a091eff3f3905b3069ec01d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1c81147e90d9022387a7ec704d8ea97f17be499532636583322ffdc97cfa543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a115ba762fa27251fa2e146d0d9dcb43d36a8ad852aef20c45b3c52aaeb3c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3e53d8dd28a4d242c49e7d0353acd52b5612662a5130c74f04aa2ba53e024b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a92c6e4c339c143989705917dc8b016762c30e546cb899712d0e96bc8d9ab61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "189ae3e0b904be7d7e43129e605a732559c004b543140129a016f0d001ad2583"
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