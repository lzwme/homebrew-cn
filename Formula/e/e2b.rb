class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.3.3.tgz"
  sha256 "433a72f799b88413d02092ed8b72213b756f6a44aa197ad1fbf52e7aae84775a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8439dd33a9c0abedb06ccfd9b43192547a5d47f93ff4103258e0c4b9996e571f"
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