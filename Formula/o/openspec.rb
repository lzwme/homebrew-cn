class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.8.0.tgz"
  sha256 "e6f049442659eba493a130220faecfc4cb7b001b300af069ae5d535e744348c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "236bd034e64a624a3c7c21fd6e69f38c276967db82e14f7af9f5c30c27fdc24f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "236bd034e64a624a3c7c21fd6e69f38c276967db82e14f7af9f5c30c27fdc24f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "236bd034e64a624a3c7c21fd6e69f38c276967db82e14f7af9f5c30c27fdc24f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ce9a070656ff898f267c13261c579c0a335891ae5d850cc503764836f19ee20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ce9a070656ff898f267c13261c579c0a335891ae5d850cc503764836f19ee20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce9a070656ff898f267c13261c579c0a335891ae5d850cc503764836f19ee20"
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