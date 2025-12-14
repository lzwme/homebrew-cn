class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.342.tar.gz"
  sha256 "8528e02c5b2b36906b6b7aa988707659ed4631375317d22a025f98653f209a34"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "671571559f557110206363bdae57ab0867cd2ff2ded322247be0cf6a6cfe805a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "671571559f557110206363bdae57ab0867cd2ff2ded322247be0cf6a6cfe805a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "671571559f557110206363bdae57ab0867cd2ff2ded322247be0cf6a6cfe805a"
    sha256 cellar: :any_skip_relocation, sonoma:        "576808a6b344a7399f40eaa88d71e7af2a262618c5541d002d08c686e0206e94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "becc9037fcf9bcff96bfde7214be5073f97746822b40bc705db2d30172cf96bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f8bb8cd8d59489258779bb5079a1b54b96f961c46e158750372575446ed4f71"
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