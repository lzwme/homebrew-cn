class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.481.tar.gz"
  sha256 "17a1870e8f339d67de58d4984c2fc4d12e2849d908ea5e1806c6b49ce6749411"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f4ddf72d5a09516321027bffaf7c8f29e142a8b14ddb919dc0c86ad5c037ffba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f4ddf72d5a09516321027bffaf7c8f29e142a8b14ddb919dc0c86ad5c037ffba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4ddf72d5a09516321027bffaf7c8f29e142a8b14ddb919dc0c86ad5c037ffba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66064233c6bfef9e489b348009bf7c2f59a474ce4f783df5c1d25687d9c6c67b"
    sha256 cellar: :any,                 x86_64_linux:      "7de65d94be882226f59e78fb666511014de93959771e5cea56bb4a389314cae3"
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