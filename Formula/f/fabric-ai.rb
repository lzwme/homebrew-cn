class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.395.tar.gz"
  sha256 "c9457af5d41986f1d465b3035e5833ee0609d5c016d893edfc2afae7ec2bbdc2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4006bfa00e304abea0ef71d84c8c3aa038178cace48b5d76c3ced1c1f0b994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4006bfa00e304abea0ef71d84c8c3aa038178cace48b5d76c3ced1c1f0b994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4006bfa00e304abea0ef71d84c8c3aa038178cace48b5d76c3ced1c1f0b994"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ebcc7763d53b93cb13e66b6f7115d73f225c2c77b08999c19ecfcecc0711544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ec1a77c4549842f4347363a1b88921c39ea704ec78b0b2ea4dd88d406bc1224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbab29e788057b047b41610d2ebdd4cfc70cd0f50d43357c39c16c737da8b156"
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