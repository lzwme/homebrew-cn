class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.400.tar.gz"
  sha256 "e0fa941ddcac1108e8bdfb72cf123595172acd4f5339b7769cd93af7ffc58c49"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6e9aa8555ba6ec011af4bd50bcf916f5bf17cb8bcb9c96764965ea6fb30269a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6e9aa8555ba6ec011af4bd50bcf916f5bf17cb8bcb9c96764965ea6fb30269a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6e9aa8555ba6ec011af4bd50bcf916f5bf17cb8bcb9c96764965ea6fb30269a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1981903ea70dd6925f0a74a5165031ce2dafac7ef8831fcf3fe9947b6d96c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3ba0e594c7744c72a86f95ec16b7cd2bfe9d11f6e3f2837319167a207ee0a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f930e587cc267793e378645dccc50f9079eefe2523bdaaf63dd9c81f210f2d42"
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