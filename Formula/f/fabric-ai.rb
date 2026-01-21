class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.385.tar.gz"
  sha256 "ebf61ffefd84166fa97e865c3a8799e8489b0ca7d98df540464596a03b8a22e3"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be3e447a2eb7132bf5da18bba83cd30d453ab28d8029e25eda9c2b038f9924f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be3e447a2eb7132bf5da18bba83cd30d453ab28d8029e25eda9c2b038f9924f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be3e447a2eb7132bf5da18bba83cd30d453ab28d8029e25eda9c2b038f9924f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a5da2d007fed4d10163f7ae96a3ced6df0ff9f856ac26507024c084f036f2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d0c1edcf91113ee223afeee92f6add4268937b40d9290f4c6aeaa6b04a2e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f15a1b66822abc560d98f5a800f8ef10d328dae2f7cca5c8bc66b80d401d16"
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