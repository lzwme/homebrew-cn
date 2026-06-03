class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.4.0.tgz"
  sha256 "b0ed5b14e3ff20ed45e1f7b5f1a37c847db437386b5fa2c98097fff8a0537f78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f85873683e2b03e7720e7551a8e3548f8c33be79e155fec11250065c4e82565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f85873683e2b03e7720e7551a8e3548f8c33be79e155fec11250065c4e82565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f85873683e2b03e7720e7551a8e3548f8c33be79e155fec11250065c4e82565"
    sha256 cellar: :any_skip_relocation, sonoma:        "7814fecfb0dc698fde8fa7fb15e7bfd0e568f5092aef55e85f84fc4e384cb675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7814fecfb0dc698fde8fa7fb15e7bfd0e568f5092aef55e85f84fc4e384cb675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7814fecfb0dc698fde8fa7fb15e7bfd0e568f5092aef55e85f84fc4e384cb675"
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