class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.4.3.tgz"
  sha256 "4e6dc81ac5c5aa104c61e87d4678f3fb6973d8a5a9dadb9b7c7578b0b3382bf8"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a51522f9e32b70fdee666f57f6d1963588c498a9a738792141d68c34f7abbdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a51522f9e32b70fdee666f57f6d1963588c498a9a738792141d68c34f7abbdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a51522f9e32b70fdee666f57f6d1963588c498a9a738792141d68c34f7abbdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "36c1965ff7dab2abccc1dc024e2d12014ac4d6e763989bd81110f69dd06e560d"
    sha256 cellar: :any_skip_relocation, ventura:       "36c1965ff7dab2abccc1dc024e2d12014ac4d6e763989bd81110f69dd06e560d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a51522f9e32b70fdee666f57f6d1963588c498a9a738792141d68c34f7abbdc"
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