class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.13.2.tgz"
  sha256 "f55cb023afca8ec4dd912b5ffae86c9d68bf24d17ad1cf750451627396b92297"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ae34e6f7f0003412fae2144edafa70c5aa1f95f9c230bfabbfa86d7bd6fabb0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ae34e6f7f0003412fae2144edafa70c5aa1f95f9c230bfabbfa86d7bd6fabb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ae34e6f7f0003412fae2144edafa70c5aa1f95f9c230bfabbfa86d7bd6fabb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4466ec9676d26ba2371ac0016a4924c20e211d9e2737f94bdaccda40ffcf85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d4466ec9676d26ba2371ac0016a4924c20e211d9e2737f94bdaccda40ffcf85e"
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