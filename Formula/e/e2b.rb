class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.19.1.tgz"
  sha256 "b57152d36bb2a40fc136944e0b92d1453b6afd0ddabe8924df2802c96042fe64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a00d6536c14454d6e644dd5aa1a40c56250e6c6f5d0d9e6cf32cd6793eeec726"
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