class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "26f932dcc307fd43b41aee17542fab2380b86602793489b851c6f159ec529c27"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b69e2f925fad3dc7baf68fea140e953ed40afc62f4dbd8d41a1953732bafdfd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84cbe7723a483dde39a9440c16b5a855579a91cfa86e0dc56bdaf3ff0f696e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5114fd77ee99c861c5a12bd1ffc879909453d886c69372f349707d84c69ee70a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a512c1e29c70b35a53ca8f76dd0837f1931bf0e07bc829b6f4da9b15d2b1efac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "741cb69e90cfdbd5d6914732fffde03dfb7cde110d41db0a40a217b476dfa1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8126a1bc606e7897c1ed66b26d7fc51347c7f2bf168ed7c25e834f9ae43e8754"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end