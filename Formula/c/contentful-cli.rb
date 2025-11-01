class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.10.tgz"
  sha256 "c768708142a3d3867ff76eefe672eb16e4c069ba41c2c501027792f67be8ccb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c6172a218ecff03262838156280b67866f8fb5948a230668ae9356a87572f9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c6172a218ecff03262838156280b67866f8fb5948a230668ae9356a87572f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c6172a218ecff03262838156280b67866f8fb5948a230668ae9356a87572f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c6172a218ecff03262838156280b67866f8fb5948a230668ae9356a87572f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c6172a218ecff03262838156280b67866f8fb5948a230668ae9356a87572f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43aee50e7a2a37ee14e7bdd0dbaaa598f512cf3a093f1e9d1937ebc22557377"
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