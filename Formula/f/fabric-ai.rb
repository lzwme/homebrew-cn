class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.473.tar.gz"
  sha256 "27fe2b8092b458c74332a30843531a16e9310607d8a7a3947802279f66f8c00b"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "604bf0896574ed03fc24141257e9dd1189fd5f3e1a2e926c8233efd64c49dd94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "604bf0896574ed03fc24141257e9dd1189fd5f3e1a2e926c8233efd64c49dd94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "604bf0896574ed03fc24141257e9dd1189fd5f3e1a2e926c8233efd64c49dd94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7853a84037d72d3e499587f85e56029480d6645ed866aedab3b6b0273d92ba11"
    sha256 cellar: :any,                 x86_64_linux:  "1d2bd8c84941805f49e1f834030b2f45869656b4398664a3ec6eb74b32febbd9"
  end

  depends_on "go" => :build

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