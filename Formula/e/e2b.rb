class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.11.0.tgz"
  sha256 "795e29e66b31078f984e723d45f702bae0c6277b1cf2bb15dd97c27526ae38d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "862649b07e3a39719c669bd783b34cd7361e21dfbd4196f73afd22cae525fa9e"
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