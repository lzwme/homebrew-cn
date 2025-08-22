class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.0.0.tgz"
  sha256 "4b110a77398ae9acb4f6f2a288b1a5874b5cb2de872165f66dc2fae117cda69d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "949e3a62924265d5086f9433520b1b5bd63ea18abc1b4b88a662e16df7c0a200"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end