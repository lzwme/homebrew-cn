class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.28.3.tar.gz"
  sha256 "96250da66bdfd7dd2eb2879d3404dd3802872f4708e67cae40ad7b2af2b70bc8"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef46be0d42ba78f798be9086cbd35bc38dd1d24c246cc21d5c5fcdc43301c77f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b794286dced5b79770a99cfee26f23bf5a5501eb2b7c356df7cd0f01ce1c857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f65470a7152f69c01af9a96e17017901152b32c81ed677fa62eb24042223a188"
    sha256 cellar: :any,                 arm64_linux:       "f9c14253bca93692779c2b7fbaa39f9845d04c187ea1de68beee39e37ce16501"
    sha256 cellar: :any,                 x86_64_linux:      "3262e5014d78701bb2871d0ae2a25e162e8f5d39e45e764fc94711d077e08937"
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