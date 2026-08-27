class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.18.0.tgz"
  sha256 "c93e42f7aad758ab2ef8af8011ecb9fc002610daa17ea177b7c406fd89fd886f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b8d2c9cddff25cca05d68a381b0514c72d1925e345e92299743c7283bc0997e"
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