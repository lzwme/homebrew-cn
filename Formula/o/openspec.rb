class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.14.1.tgz"
  sha256 "4a88e334938316db6916fd4f3aaf2213e6fc23b4fe327efd2afe7754c2d3b0bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb1162151af59557391b838334bdcd606dbc72f04b5c783f6575eafcb338ec88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb1162151af59557391b838334bdcd606dbc72f04b5c783f6575eafcb338ec88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb1162151af59557391b838334bdcd606dbc72f04b5c783f6575eafcb338ec88"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a40746ee2f4e5e5fdcb7df6095fa0c7b605da2f2f9ed0ec921efedcd3efc944d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a40746ee2f4e5e5fdcb7df6095fa0c7b605da2f2f9ed0ec921efedcd3efc944d"
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