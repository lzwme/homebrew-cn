class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.2.8.tgz"
  sha256 "54827e1a7c0312915095847f6891627c2bbd685d0f74b26e93e6decc98b78e59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1fdd17fedc6d5311642fef53f36bfec8c9051b86d0533b636941e57380d97a2"
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