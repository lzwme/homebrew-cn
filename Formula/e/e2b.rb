class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.12.2.tgz"
  sha256 "79e15374317897902f9aef41ecd3d072c3087c321cac9425b20a763e1f73ceb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94615798daefb867bc489c9bfd3acae8c1b00fc73d9c2f3ebb6c6e5d658767f1"
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