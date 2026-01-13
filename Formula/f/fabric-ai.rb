class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.377.tar.gz"
  sha256 "ae98a27866196f147e355405d64b857ca86d11751d592bd406777ead0fbba066"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "635410dc6bbbe8241703ec61b9d2daef14a918509456627aaceb6ae351e72a4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "635410dc6bbbe8241703ec61b9d2daef14a918509456627aaceb6ae351e72a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "635410dc6bbbe8241703ec61b9d2daef14a918509456627aaceb6ae351e72a4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "94703bbd7836a1ae614391e3512810eed49806c454ff066d503fb9505dbab14b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f98925c67e6800d4acee9bf06907577f6bd981bb1ed3b983ef9d21eb2cb94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426d28e4aeeb2eb4e1712de94bb94940739e6f47274f02bf3323f36d26ac08c3"
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