class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.13.1.tgz"
  sha256 "9eb2c97da151f768d465faecfb0ff00a3dd8fcac31145934a730f12fa32089ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5d26187dd0aae382842ff393456ebddc478da9f8febc46fef6f963c06fa9c96"
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