class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.427.tar.gz"
  sha256 "f35467a0c0d2f7c7f5437e90a0d7fa2719484026214bad0670df293d944abfbb"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bda1941173ee66c43d52e6de462d588eb33b316da3905e13a66c119a8c71e48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bda1941173ee66c43d52e6de462d588eb33b316da3905e13a66c119a8c71e48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bda1941173ee66c43d52e6de462d588eb33b316da3905e13a66c119a8c71e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "444732538ce7f2f5d340f7ba5861f03cddf71aeac538b56983cf4a3e83fffc2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc76b564bfd00c90812b3f533a08bea2cd3efe631fa76e9139839e9dc83b6d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff7db7a49872de0ae5ca100e127ca51a88a8b8cbab72d42112b6c8f8b5af76b"
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