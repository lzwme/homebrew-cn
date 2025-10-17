class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.3.0.tgz"
  sha256 "f875763c0086d9f04857ed348a7c2f9747ca932800be5dfca6b6b2ec418b8888"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff12f02231da600c78a3868641d1a04e3dbf84596e53b98898bdca1a8999f0fc"
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