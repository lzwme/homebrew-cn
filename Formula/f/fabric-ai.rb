class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.375.tar.gz"
  sha256 "d2fffb89ad8f4196ea2458ff3a1b2c2f94699114ae5e057ff1aa4cef2bdcd750"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5619d5264e7717678bab1b495610521a51ae4545b8c4f2e4feb3a8e0e2cc498"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5619d5264e7717678bab1b495610521a51ae4545b8c4f2e4feb3a8e0e2cc498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5619d5264e7717678bab1b495610521a51ae4545b8c4f2e4feb3a8e0e2cc498"
    sha256 cellar: :any_skip_relocation, sonoma:        "c66454501490cb647343d7c0a46871b100c6ee3b073ebc2bdc6bc94d34fbf869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1afead27879d9842302d5689d8fb4f1b234bdd5cb394948983572c5c7f7f3626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe946c57dea07ae227c825f93ab6b01ac26b9389c6c45469cce8ae9b7401328d"
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