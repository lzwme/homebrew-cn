class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.0.1.tgz"
  sha256 "e73d37d72724f59504c7d9661e2565d50c9fc1d067c9029bb9cc8315c9675b5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "31d16be552ba0032f9e780abc143e86e1d18cd64030de286b3974ff9322006c9"
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