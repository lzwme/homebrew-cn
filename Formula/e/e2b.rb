class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.19.0.tgz"
  sha256 "3193dde4da7287980586feab033876f2cc17a964387dcab4117f43c0dd37fd37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef103f736c797e0a1a9e4c4289252376d6eae5b33077b9515bf70fdb0d432fd4"
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