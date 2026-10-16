class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.520.tar.gz"
  sha256 "475940160e459609bbaaf16f47ca193ff5712857e77d6fa591f0c575ca28fef0"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3191f5ad1f7de52718399f301cf3e3914df8ac9df8ae126493a110bdbd01a43f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3191f5ad1f7de52718399f301cf3e3914df8ac9df8ae126493a110bdbd01a43f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3191f5ad1f7de52718399f301cf3e3914df8ac9df8ae126493a110bdbd01a43f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23b371ece1c920239da6fc1ba41fa8b77cc0d2697c46a6f1083104541948d0c8"
    sha256 cellar: :any,                 x86_64_linux:      "bac230be863835f10bae914ea760abe0e38787686568a0927b4b6402a4f2121c"
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