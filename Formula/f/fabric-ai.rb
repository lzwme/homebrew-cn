class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.320.tar.gz"
  sha256 "5befa8be1538b37d3582478b2ab75d316d3ff087c382f3bd155849b3c5977ed3"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0abffb7d657b3a90f7a32cd6c653aaaddd8cac203c2e0a8a3887bcf45b9be91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0abffb7d657b3a90f7a32cd6c653aaaddd8cac203c2e0a8a3887bcf45b9be91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0abffb7d657b3a90f7a32cd6c653aaaddd8cac203c2e0a8a3887bcf45b9be91"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1662b33f8a19a9642de08d36a55001242d3d110d42d04a568ec0ed4b165c30b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86e6ec7a9aa1d4ffc1414857d6c3015c68ea194ee8d041957f8a0f9ddb7d8ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e895c5f998d3e468185186e5e95a4e2c6d606a5603edb05e4b67c77228bcc4e3"
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