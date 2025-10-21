class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.3.2.tgz"
  sha256 "a49a8746cee66f23b28915d3bc868210cbbf39bf0905e1262167fa06dc1fbba9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04c6a798baed1838ea41271c15fbec010883b4bf341e35a0367c4f5721fa95dd"
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