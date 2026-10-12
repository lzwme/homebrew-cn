class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.29.0.tar.gz"
  sha256 "be35cae8a658f19739e764037d297914b83b82694ffb3e586f4425062d528905"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d806bb709f1b6a6da5876958c4eb4a6434d26ac7f7a47dca5caa70202cc9b332"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "945459a71a49e0130fac8f16971e5a2c09f15d96708e1010b97db687de7b5416"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3307b18fde6acd65636add29d07a90a9681e02b17cf86b446275d0faeb839eae"
    sha256 cellar: :any,                 arm64_linux:       "70330cc358c3bc7c1da123ae5718aa3bb9a4b900aaa688fc14f1bac34e083d6b"
    sha256 cellar: :any,                 x86_64_linux:      "3d0a2093c1821657d9dfa5597a86978191285a64973c80eb0b963bb4b1579dad"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/leaf.bash" => "leaf"
    fish_completion.install "completions/leaf.fish"
    zsh_completion.install "completions/leaf.zsh" => "_leaf"
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end