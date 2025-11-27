class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.334.tar.gz"
  sha256 "c661f95b2df12fe764b1ff11d5606504bd6723e92a35475c63e7281ad63813d8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d22b701b5ae29ed32ded3e52becb8b11c93f386115e23aa65cf5196116c9a912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d22b701b5ae29ed32ded3e52becb8b11c93f386115e23aa65cf5196116c9a912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d22b701b5ae29ed32ded3e52becb8b11c93f386115e23aa65cf5196116c9a912"
    sha256 cellar: :any_skip_relocation, sonoma:        "52811e3cc8c999eb7e62b956cf8008a1ebcd3ade5b9c4fc2c2c578f0a96e84b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b6c73a42988047be43dc2d32df9f49a16bad7e33ce1590e8372e9d1cd2202cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34359743d3e20273adbf0f92dbdc061480a1187a4b27ff9d58d9ca6d50ec89d9"
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