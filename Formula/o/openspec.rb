class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.11.0.tgz"
  sha256 "84820b173b57204bd7582a47ddae65e85fd492724172acc8e434e97ea1c05c3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48312ace8602075595c6a8fc314ed250e2bcd5155b64ee87c5a973114146f66c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48312ace8602075595c6a8fc314ed250e2bcd5155b64ee87c5a973114146f66c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48312ace8602075595c6a8fc314ed250e2bcd5155b64ee87c5a973114146f66c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1d3b4b449997771f9b355b318687d751a0194c5e6372a6fcb32af62d7a9e42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d3b4b449997771f9b355b318687d751a0194c5e6372a6fcb32af62d7a9e42c"
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