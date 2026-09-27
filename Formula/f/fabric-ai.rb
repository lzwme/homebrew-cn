class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.486.tar.gz"
  sha256 "f2d934d6496de3d682f099e0c4e0dfbf971d8176d4da2479ceaf319358d71a60"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "738cf4461259d3079614101b4b009623a0f9b84308a7804f9ffa62c336824307"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "738cf4461259d3079614101b4b009623a0f9b84308a7804f9ffa62c336824307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "738cf4461259d3079614101b4b009623a0f9b84308a7804f9ffa62c336824307"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87316b1a5f4657d34205a18d33aa2328f65e65caa21d9001a81e9a2e29ed9140"
    sha256 cellar: :any,                 x86_64_linux:      "41d3a06bb85920dcaf5b683089f2206e1bdf4a8326992164cfdb77c0dbe584ec"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
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