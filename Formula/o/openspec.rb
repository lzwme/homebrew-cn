class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.7.0.tgz"
  sha256 "3e0bd044bf1fae1732f201fab7b5c1c8ceb4ef89bed9923f89a33cb4f0750afd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "686317b17d6e8027b2db878dffe5f5ce3457ef24f4f52c70d73e78996ce125ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686317b17d6e8027b2db878dffe5f5ce3457ef24f4f52c70d73e78996ce125ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "686317b17d6e8027b2db878dffe5f5ce3457ef24f4f52c70d73e78996ce125ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f967c8a40145f198972f4bcca9b77b594d1fcc319cde56b814b92efb6cc293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6f967c8a40145f198972f4bcca9b77b594d1fcc319cde56b814b92efb6cc293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f967c8a40145f198972f4bcca9b77b594d1fcc319cde56b814b92efb6cc293"
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