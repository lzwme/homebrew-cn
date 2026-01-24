class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.389.tar.gz"
  sha256 "546657759e34e3e9edf983bfeb70df1683e02037eb6035b54e6beb18c5ab89dc"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b1700e013c2cd40bd1385729bbaa0712facc36ccdc1cff5524f8fbabece9132"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1700e013c2cd40bd1385729bbaa0712facc36ccdc1cff5524f8fbabece9132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b1700e013c2cd40bd1385729bbaa0712facc36ccdc1cff5524f8fbabece9132"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6438046c30a5ae1e8d5aff8da67385876c6e8de6fcc65f11f0a1699138dc3e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96f28ea23301a7e1b0aa6dd55da11c5e62270338520f7d5e75cf43b572c4a387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e09a693a1aeba522bd81619fef189c1c23ff82684d74a5e4bca2d1d1ba4f0e"
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