class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.526.tar.gz"
  sha256 "8414d16dc644758c49425e8658402c73cc788602a5aea928549f313a9f6e2158"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c528b5008c66ca144a3b29a6dfbd521e7b66097d74429e46da252d2afc9385e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c528b5008c66ca144a3b29a6dfbd521e7b66097d74429e46da252d2afc9385e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c528b5008c66ca144a3b29a6dfbd521e7b66097d74429e46da252d2afc9385e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2170b8608c5519fe3caa9db3c9c8ab8038252c481f4ff1b817859081ff17802a"
    sha256 cellar: :any,                 x86_64_linux:      "bcb54553addc429ea3761a48ec57f5c8defd0f2a5a42f2b75b49dcff6ab8d46d"
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