require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.0.2.tgz"
  sha256 "f35cb88e0d1e5b146b417b439d6409f7fe9f1a34ca4d3ad0a4c2dbf36357d887"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed783c99c44a20a3dd6d7cc0d852f1a6517f6214a60608b2b0ee8e818d985580"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed783c99c44a20a3dd6d7cc0d852f1a6517f6214a60608b2b0ee8e818d985580"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed783c99c44a20a3dd6d7cc0d852f1a6517f6214a60608b2b0ee8e818d985580"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb26b5f19d70792b41ee0303e42eda7d1c686f6f7016941e7e9b51d7abbd1b2a"
    sha256 cellar: :any_skip_relocation, ventura:        "cb26b5f19d70792b41ee0303e42eda7d1c686f6f7016941e7e9b51d7abbd1b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "cb26b5f19d70792b41ee0303e42eda7d1c686f6f7016941e7e9b51d7abbd1b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed783c99c44a20a3dd6d7cc0d852f1a6517f6214a60608b2b0ee8e818d985580"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end