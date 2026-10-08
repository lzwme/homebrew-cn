class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.516.tar.gz"
  sha256 "84082202de0e8979cc6d211373456564ae52d3eeec97de297e3ab809cded5755"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5217907e2e7c4e55adc33e705359db9770aa776115484a0607b6d67df7a03d59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5217907e2e7c4e55adc33e705359db9770aa776115484a0607b6d67df7a03d59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5217907e2e7c4e55adc33e705359db9770aa776115484a0607b6d67df7a03d59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39f5814da543ab4a9785c1051a5c9d19abc6643a2a1bc21cd7b5148d7a4c5559"
    sha256 cellar: :any,                 x86_64_linux:      "7221276bfb75cbadf635159bb8e43bda60a8d774b97f03470e9c5f83b7bf510a"
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