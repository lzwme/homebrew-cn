class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.16.1.tgz"
  sha256 "703c197e161fcbfe9056beea6ac498d0de1f193c3648800cf79445a3fd0e90f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ccbd5f429deb7080f1f8eb210d2b93a31de5f6484ec261db258f07e2672ac30d"
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