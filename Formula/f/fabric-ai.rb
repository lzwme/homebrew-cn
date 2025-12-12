class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.341.tar.gz"
  sha256 "adeffd3eed1cc3e8f23c5d2b0d6854af1bf220aa7d3cb7f173dd5d3c6051b613"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44d87e1598c439475826ec79299b5e1931f7071c61e173c890c5076ddc89ab53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44d87e1598c439475826ec79299b5e1931f7071c61e173c890c5076ddc89ab53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44d87e1598c439475826ec79299b5e1931f7071c61e173c890c5076ddc89ab53"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f712bebc00754df9e22d69281a0b479dd16cb798cd58859f5e0349c1f01758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2764709ade12422a899bbf405a7f0ad144a720c2c3b58488c9e2af0d4b510f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c059ef388ada404ce7ebaf297fe094c586cf403aec6e63c0926aa8b6b65a4ccc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end