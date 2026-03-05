class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.8.0.tgz"
  sha256 "0fe3aa49c6fe041169fbe11de5b92215253210620b5297c241f2c68e77d4669d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b11dd4cf2304383a8f7c967e93c6ca3823ed8f5b055336ac6fa7a39a729756f4"
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