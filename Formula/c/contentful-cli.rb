class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.6.tgz"
  sha256 "362d217ee5d9f81db585d3eed728828ed0376e47e14cf859b1da68a9fdd56a3d"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41ae2fd9fb01d850a8604c788d8850e36f42d07cae6e679f2f7ad6f56c4490b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41ae2fd9fb01d850a8604c788d8850e36f42d07cae6e679f2f7ad6f56c4490b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41ae2fd9fb01d850a8604c788d8850e36f42d07cae6e679f2f7ad6f56c4490b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d52b1af236ef9ae1f6185709d6a32b6a550d172861af7de0fb733d8b92b3331"
    sha256 cellar: :any_skip_relocation, ventura:        "6d52b1af236ef9ae1f6185709d6a32b6a550d172861af7de0fb733d8b92b3331"
    sha256 cellar: :any_skip_relocation, monterey:       "6d52b1af236ef9ae1f6185709d6a32b6a550d172861af7de0fb733d8b92b3331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41ae2fd9fb01d850a8604c788d8850e36f42d07cae6e679f2f7ad6f56c4490b9"
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