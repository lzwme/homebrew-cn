class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.8.tgz"
  sha256 "7138aa521c5dd639cc7ee68d958f52ca3c8446f128a6a1b8c38816c99fa82d2e"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a97653d0b3a90fe3a852fa1f0a2d0d23957bc25bb417aa3292faa571eeef2e5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a97653d0b3a90fe3a852fa1f0a2d0d23957bc25bb417aa3292faa571eeef2e5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a97653d0b3a90fe3a852fa1f0a2d0d23957bc25bb417aa3292faa571eeef2e5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "41f9086848bd62b4e548bb12fb8b94da3ff36dc5f9b76e04bc69ce11e0617c60"
    sha256 cellar: :any_skip_relocation, ventura:        "41f9086848bd62b4e548bb12fb8b94da3ff36dc5f9b76e04bc69ce11e0617c60"
    sha256 cellar: :any_skip_relocation, monterey:       "41f9086848bd62b4e548bb12fb8b94da3ff36dc5f9b76e04bc69ce11e0617c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a97653d0b3a90fe3a852fa1f0a2d0d23957bc25bb417aa3292faa571eeef2e5b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end