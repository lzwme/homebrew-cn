class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.444.tar.gz"
  sha256 "217397ab52a7198c8fb5f05e87b4f5d8b321ad35a93aaafdcd738a5e529df26f"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9dc3e8e58002a60b88460f9b3ad91a3b4860631c70455f8795a4043b6356faf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9dc3e8e58002a60b88460f9b3ad91a3b4860631c70455f8795a4043b6356faf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9dc3e8e58002a60b88460f9b3ad91a3b4860631c70455f8795a4043b6356faf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9693578b6c897219d1f206b4ec614e2e930eb95dd4ed4ca0fd333d9acc9e8e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a2b17b8f6fc4a901cd0292ff1236f587ce37f38c2d8bf05b46bd3db9c10447a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94397a01f5393ac25647f506fb7677060d43a3de7185080b2fe72a5ed5a327e"
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