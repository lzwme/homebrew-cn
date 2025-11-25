class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.332.tar.gz"
  sha256 "e6575a2502b3bd70808d8738ac2240a2166290e32136cd3e1fbc6d1ad7720b71"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a718f7fdeb96b3d98423991ccb9f40dd8697d33756cc4116da708cc74228c95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a718f7fdeb96b3d98423991ccb9f40dd8697d33756cc4116da708cc74228c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a718f7fdeb96b3d98423991ccb9f40dd8697d33756cc4116da708cc74228c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bed9bd359669eddc0cb93b39584ff96432ea8051b85b4cf216c01b62120d1a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f5fb1ce27903284552f279643583885c5846e2d8465c7148953446811faca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33bfbefe5c6c7f03a9f7a75728465ec1a51f0fe8ba1e72df7e24c356c4c525ee"
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