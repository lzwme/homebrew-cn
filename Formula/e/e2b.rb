class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.15.1.tgz"
  sha256 "01d35cd5e1539114757e7c1bfce17883cb9f22e9198b07a5b8b1e9f0ace86ab6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a737b890816c2c17db70cb7c7e40b1fb2860fb46a76f21c7483c91afabc7f4b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end