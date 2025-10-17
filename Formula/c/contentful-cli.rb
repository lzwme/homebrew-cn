class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.4.tgz"
  sha256 "03f6192e74390ff18fc0a8463a7c351536b0e41fe24a792a193b9aa902d363ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "928e5c253860b1d80d7126cba733a2fcf8499f6027c4e4f20e536030fa944f41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "928e5c253860b1d80d7126cba733a2fcf8499f6027c4e4f20e536030fa944f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "928e5c253860b1d80d7126cba733a2fcf8499f6027c4e4f20e536030fa944f41"
    sha256 cellar: :any_skip_relocation, sonoma:        "928e5c253860b1d80d7126cba733a2fcf8499f6027c4e4f20e536030fa944f41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "928e5c253860b1d80d7126cba733a2fcf8499f6027c4e4f20e536030fa944f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a31cd594f7994e2102ebdc0e179f5e7bfaa3848abf1ef050e3ef5013ddeae0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end