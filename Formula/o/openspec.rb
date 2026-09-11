class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.13.0.tgz"
  sha256 "f3c129f3f1e3aece105a4c1798301c7b6faeacec8a30eec8def63787e4d59ace"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9bf8ec1e98e99115bb3cb536d5f2e1ce122a93a5af525ac60f78e0abc98de3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9bf8ec1e98e99115bb3cb536d5f2e1ce122a93a5af525ac60f78e0abc98de3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9bf8ec1e98e99115bb3cb536d5f2e1ce122a93a5af525ac60f78e0abc98de3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38c1510bf58bb70979d2e55f7fa7cdbe0fcb71c72ea9b9986d9b2ae78fd260ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "38c1510bf58bb70979d2e55f7fa7cdbe0fcb71c72ea9b9986d9b2ae78fd260ba"
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