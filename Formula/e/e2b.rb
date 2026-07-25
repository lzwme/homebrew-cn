class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.15.0.tgz"
  sha256 "f9942d921db9244cb04fa9e798f284c350887a1cff4256df04bd661278358c56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a01321d9c4189f1085232a38005c2c42a81ed250cffc34a20bf235bb99c6339b"
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