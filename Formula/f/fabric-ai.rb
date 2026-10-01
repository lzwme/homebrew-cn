class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.497.tar.gz"
  sha256 "9dc389ef61888dd9dc4485521320bba3ae27c7bd9376c1f7e004b465678ec3cb"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b5cce3a7cbbb0731c81d1f79777a4d2d93e5e1a2cba29475197e25896f22484"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b5cce3a7cbbb0731c81d1f79777a4d2d93e5e1a2cba29475197e25896f22484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b5cce3a7cbbb0731c81d1f79777a4d2d93e5e1a2cba29475197e25896f22484"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a9cff846f4588167bdd5c08ed81f6eca2afba01ec6cb4876cfa7b9ffc9af14ba"
    sha256 cellar: :any,                 x86_64_linux:      "3577093971cf558295224f505b7c94184dfad1e3757d41f655a4aa16716a0cad"
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