class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.21.2.tgz"
  sha256 "7e5031ce254e327b9904031938b0a3885603edc6f6b06bf612a1207dea0bd0a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba10d2f59038e32cd04a4223b55fa665b35589914997d07389e230cb7b8a3d0c"
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