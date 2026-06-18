class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.12.0.tgz"
  sha256 "d1e0ed6a06f6109dea87c62f6bc33a85a8b8abc0a4c02e799ca3f41be585ac80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc34afd900e0c67253359b0bb1e07fba3b3c6478ca13e6ecff59a52e07fe738d"
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