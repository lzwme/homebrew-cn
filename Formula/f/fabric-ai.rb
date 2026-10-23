class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.541.tar.gz"
  sha256 "a35c650d46c2e09004c3251c1a01ce5eedaa112ee769cdf6890a6df92c6c957e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9d81b0d439663b79ee7ce04ceae397d02ce89896f8843f5ced37417b9939bbc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9d81b0d439663b79ee7ce04ceae397d02ce89896f8843f5ced37417b9939bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9d81b0d439663b79ee7ce04ceae397d02ce89896f8843f5ced37417b9939bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cbff408734030678d9ec78146a17ea156ee97a8b426e5e6fbbb1ae42277e43cc"
    sha256 cellar: :any,                 x86_64_linux:      "752e5340c24a3330d3d61823490c014c64bcf12149ce66021b81c6975b0559bc"
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