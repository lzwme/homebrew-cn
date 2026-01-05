class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.373.tar.gz"
  sha256 "280abce875265fa2aaf101183e46c80704ca940131afb7f0bf48d5aa51f60507"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c3ede8024a7156f7a3a6fe6207067e601c5ae69827b6bfbb1443c29c714261f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3ede8024a7156f7a3a6fe6207067e601c5ae69827b6bfbb1443c29c714261f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c3ede8024a7156f7a3a6fe6207067e601c5ae69827b6bfbb1443c29c714261f"
    sha256 cellar: :any_skip_relocation, sonoma:        "83d97d1ae5b8e7b2a7d9f75b2f5f31dadc8d8dc6d8a8ea12efd7fd36ca00fa52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3bb7e188b7ea548c0090a4cd3084fb7aa82c610d1004105cb7a406565a91c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b5848e678cd94a26ba6bc13b5b8b5dcb1bfc2c2b95bd50f8f92d8192e5380a8"
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