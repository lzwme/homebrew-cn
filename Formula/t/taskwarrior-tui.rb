class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://ghfast.top/https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.10.tar.gz"
  sha256 "7b78c15ff8f5e565b8928e63942c2ca207b65ea0b327bf4df00d0e1e3679bb9c"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a17a4abc24a415b9e1ade5ac4f71a6e9127611bba58425d66125fbbd6c426f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f39584c14a6d34c65bfda37b507314aca590659e9b5fe967d35d324ee7390425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ffbb5b723a040eca15b2e19aa33538446a3b57ffa7a24edfcc8f2d1fbfbecd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4290b8070faeaa1834414887c8ba6beb87b54598b0d6f2809d011038f1af6587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "625a42fa3d043198ac1b34e875cd2e248a2fdcdbdf62d21b9c727e4dead27d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7c5d3afc3eaefc21d5dbe7c5a4772ca5b5fe7d3047baa7bf62338691973946"
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