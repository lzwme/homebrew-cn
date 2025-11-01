class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.4.0.tgz"
  sha256 "6ea94fa2ce5f4c7937cc8016cbe6d5f96a8128af5267eb107fb85e27203c3bbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b930de100502272b2daa324c9a804d07ed6b47c1a2bed79f96f7bd3b51368e25"
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