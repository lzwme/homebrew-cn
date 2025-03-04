class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.6.tgz"
  sha256 "bb081ac570fd742ccd67ca8cd4641550fada5a0deae34466c3905492efbfb329"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e5020e175b12c35c2fb9e27968966f92395a59a8efa1e2088bfbf0470896cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e5020e175b12c35c2fb9e27968966f92395a59a8efa1e2088bfbf0470896cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e5020e175b12c35c2fb9e27968966f92395a59a8efa1e2088bfbf0470896cba"
    sha256 cellar: :any_skip_relocation, sonoma:        "0baf651b5fedc6bad70f5af9283c81c7422b885ed827f6c943c75b90c75b2d75"
    sha256 cellar: :any_skip_relocation, ventura:       "0baf651b5fedc6bad70f5af9283c81c7422b885ed827f6c943c75b90c75b2d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fb4e9b15b4f44b9381143096940dbeb9ed0fe0c44d18165852f563cba88d6f2"
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