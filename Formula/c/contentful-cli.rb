class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.7.tgz"
  sha256 "731c48231c195332a52f3b33d0e31b3892331ec236be1d3858f4eaaaeff4de56"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b272d0a7fa064712b46cb3cef48ec013f565b4320d447400f0901c58e989bfaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b272d0a7fa064712b46cb3cef48ec013f565b4320d447400f0901c58e989bfaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b272d0a7fa064712b46cb3cef48ec013f565b4320d447400f0901c58e989bfaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "411c4eddcee150192843aa67dcc8add25aee71bb04ba9e84f3c03ff3a509c558"
    sha256 cellar: :any_skip_relocation, ventura:       "411c4eddcee150192843aa67dcc8add25aee71bb04ba9e84f3c03ff3a509c558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1090d35547f5abbbd80c1a1c2f7c45f739ec727701911ffe3b415636222ae9c1"
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