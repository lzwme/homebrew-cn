class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.22.3.tgz"
  sha256 "ad46571fb8696bcdf6df385802db4f3ddcb847d30b548c1a26bf90cc29167077"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73219c88f5bb7d4508bab6d29fcbb5e9f71fc4ff743e07966d85d64380ef53b7"
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