class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "2880bce4b80dd2d3823d77cc659cffa97d764a83c70ce90a14ed538559c9fc3d"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca8fecb4d6ab9da06bd55c95b024cb9c04ee9fa87d69b79e70bf75090014ff3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4cd8b0a592e504d9e3d96b4ea11bac9abe9162f487d1964021cc3c89dd2114b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22dcb8e2f5cba7c77e4bebb4f55a8418a6e64528833ebb44b3967b38cbc6b7bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "71e2d98b7b976e6dce6813894479e440aa63395a24c7a7d5eb5a6968863cca6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb42df95058a7be76e5195b14381476c7070d5b1de1e5c358a6f3b48f97a5b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d49eb3155d81d08f1ada4e9b26a1ef569284b322c88f94c4e985ba90700697d"
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