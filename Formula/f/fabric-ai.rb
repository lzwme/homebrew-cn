class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.401.tar.gz"
  sha256 "582d7ffdb5353cec5f105bf3738718a40da84433dd67141ab1b69a2f8c8c91c8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c80985b1ca6deefe09df9bcc0f642d79ce101e7a92cb8b94ae3ddd0d3564010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c80985b1ca6deefe09df9bcc0f642d79ce101e7a92cb8b94ae3ddd0d3564010"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c80985b1ca6deefe09df9bcc0f642d79ce101e7a92cb8b94ae3ddd0d3564010"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ccc2bf510f3494b66256f126741235bf86733d4892a15f314d3fa7a98f21c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc23915ac999ed3e34360a71531a8f57f40cc5d482d4355e4cfec60d5b2bcc33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d411c796d2ced68b277a2da2eb255e0523d41a970baa7eaebca6d695150095"
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