class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.9.tgz"
  sha256 "197621440b902ed276660646ebb0af29d9b91c8c516073c184387ee51c487597"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f678ed99b4843e7b9ed327566d5a117103f5df6f9abe6b0b3ae007d4361ba90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f678ed99b4843e7b9ed327566d5a117103f5df6f9abe6b0b3ae007d4361ba90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f678ed99b4843e7b9ed327566d5a117103f5df6f9abe6b0b3ae007d4361ba90"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f427834a0bb127208a1345160ce408402072fdc3292c96a730d69f96ed93c6"
    sha256 cellar: :any_skip_relocation, ventura:       "32f427834a0bb127208a1345160ce408402072fdc3292c96a730d69f96ed93c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c8f6afe554f731ed7b06d4b53fe794b878f9e31e73cc6006f423a51f282f66"
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