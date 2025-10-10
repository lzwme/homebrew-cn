class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.2.9.tgz"
  sha256 "af1efd5efa291782b8c2fbb039d12f11b8b244c901711d818eb893f81512ed99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "54be0351ad44e75e52833ec2e3d1c471b385143a20b6e3b7e1acf2a7fcf3f0aa"
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