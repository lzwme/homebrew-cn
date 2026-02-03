class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "52954182580ee33a009dfd3d9b4ebb6a640426aafc97cc993fba9bf3bd9377aa"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d126c53475fcf7821deac4a62615984e76860e002712d9941d2888e0d75a73a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0563dcfa3538a47797d8c975949e7c9c1620b2790d544583be2cf01f4c64f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e40ab519887582196099edb5728929192785337f9b5c5a25ab25b50e432d45"
    sha256 cellar: :any_skip_relocation, sonoma:        "9323c59e53c753039388a7ebf6e133a6fd0ea8fa7a16a926c2234a45bf95b3fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "282a6af4d61be5ab258ad3f0511b4d7a5f2c10c47252cafb2b0771dd36aa3f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfc9d5035110a02cfab72c920ecc81374c4fbbee88626ba79e01cfdb8a4d1bb"
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