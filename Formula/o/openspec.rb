class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.14.0.tgz"
  sha256 "9cf16ae39a9c1e23350fabc5aeca1e697d08016a501b71382293a04919674e44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "984a6000d34a30bb0063d037a56ae4d4f600992c86dd85662e57bfc8b8e21140"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "984a6000d34a30bb0063d037a56ae4d4f600992c86dd85662e57bfc8b8e21140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "984a6000d34a30bb0063d037a56ae4d4f600992c86dd85662e57bfc8b8e21140"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "33eed7dec9f690ae3a1926af100a22e1a22eff75cc05ff3450e5f0a39a7d169b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "33eed7dec9f690ae3a1926af100a22e1a22eff75cc05ff3450e5f0a39a7d169b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end