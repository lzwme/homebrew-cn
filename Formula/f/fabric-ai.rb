class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.518.tar.gz"
  sha256 "2cef4d13f3dc884ccd7474b4b66e66248bffb7ccd23e3f05d5ee27aa19b743ae"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "709fe33d3e01a542c3c6eaeedb200a80becfbedaf44a7692301fa731e313728e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "709fe33d3e01a542c3c6eaeedb200a80becfbedaf44a7692301fa731e313728e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "709fe33d3e01a542c3c6eaeedb200a80becfbedaf44a7692301fa731e313728e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e0b909c3cace666068f455275f74a802b59e62f19a25cb15ab78dbd0331a3995"
    sha256 cellar: :any,                 x86_64_linux:      "3bc31d5e616cd8b217b6d06c01505df9435f2cb6e3e44d12d957676fdcd6941c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
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