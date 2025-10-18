class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.3.1.tgz"
  sha256 "2c5be94d136e5f86b452f8cbb9151581ad239ee1493d2da301462fe167712679"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8e5038823c5698e55a395f8f58f816dc78ea5cd6e07452866111b607b9e3575"
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