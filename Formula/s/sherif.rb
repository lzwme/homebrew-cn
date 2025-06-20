class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https:github.comQuiiBzsherif"
  url "https:registry.npmjs.orgsherif-sherif-1.5.0.tgz"
  sha256 "9d34335e549940b1aa0ed4c2d96f6794863904ab30e9461c7bf8ff4dc879ca70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0f5b57ffef3fde2495c113e8b359cd5c9bbba8684b5af005899577003faa887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0f5b57ffef3fde2495c113e8b359cd5c9bbba8684b5af005899577003faa887"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0f5b57ffef3fde2495c113e8b359cd5c9bbba8684b5af005899577003faa887"
    sha256 cellar: :any_skip_relocation, sonoma:        "a138edf56a70d681774c156503f69cb76cb34d37a15e5085da729d44f3f2d771"
    sha256 cellar: :any_skip_relocation, ventura:       "a138edf56a70d681774c156503f69cb76cb34d37a15e5085da729d44f3f2d771"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2886489f1f4e7cada411a3a2a7ce3b829678db6dc98c4bf7a93b1ed30fa298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e316ba6057c8c942c27283006dbffb9858befaf24480f1b66351beb3ed2c3439"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}sherif --no-install .")
  end
end