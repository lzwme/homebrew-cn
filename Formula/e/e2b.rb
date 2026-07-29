class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.16.0.tgz"
  sha256 "2d38e270ac0a55d8939a2eff8b48a3b04154fe9a9c1b22e1cfe866e9fdf1790c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "247e0d79975fdf47ade3dfdfa85a23f292334c5be7da5a4fa74293ea78586d52"
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