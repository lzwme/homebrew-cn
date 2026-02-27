class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.7.3.tgz"
  sha256 "6a2733f424a957f8ca3e395ba97a593e295c14363d24d98de76ce2a12bda5f78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad77cf51b961ee71e3438c09e3e80fa400216e1268a8ee9bd23d46541517404a"
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