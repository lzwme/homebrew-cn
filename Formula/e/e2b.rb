class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.2.2.tgz"
  sha256 "b32dae800b887e1838ffeb42f1ec774eaa343361c1bea2944bd333dd58dc1bd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5796e371acb7af1f75f54a7f8fbc57f32ff7d5a70f0a83d0ae625c2445ca64ee"
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