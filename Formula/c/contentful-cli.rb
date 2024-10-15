class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.19.tgz"
  sha256 "c9c501c6c2ba7757b37b22d53c1f5c21544f37e464628f53e6be328f30460f1b"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5fcbca039c435cee1df548f1f9d3d412d7cc642c6d7fce25ebcdc80bc7b0f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5fcbca039c435cee1df548f1f9d3d412d7cc642c6d7fce25ebcdc80bc7b0f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c5fcbca039c435cee1df548f1f9d3d412d7cc642c6d7fce25ebcdc80bc7b0f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a488dfb14ba075f7f3d067853c6856725e92f975f368de6a57f3073c574d3755"
    sha256 cellar: :any_skip_relocation, ventura:       "a488dfb14ba075f7f3d067853c6856725e92f975f368de6a57f3073c574d3755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c5fcbca039c435cee1df548f1f9d3d412d7cc642c6d7fce25ebcdc80bc7b0f1"
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