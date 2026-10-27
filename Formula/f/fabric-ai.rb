class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.556.tar.gz"
  sha256 "1c3dd5e9d5b6a9503adc2d4c0495b54f285426bb461af3d6043f331411b19930"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c139892a067a526c8bffa7318cf592edea103bcb6c1241f97f88b807307dcc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c139892a067a526c8bffa7318cf592edea103bcb6c1241f97f88b807307dcc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c139892a067a526c8bffa7318cf592edea103bcb6c1241f97f88b807307dcc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "07690b35b8c9491c8dd4cd7a360fbb36fee0c4ff0e85077d78a6afb8be6c6d8b"
    sha256 cellar: :any,                 x86_64_linux:      "af4f71880da896ce8bd2fdb6fdb0637316783d81d13cb7c694e8df24a0dbd8c2"
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