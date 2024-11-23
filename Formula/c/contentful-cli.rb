class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.6.0.tgz"
  sha256 "6e32a0d597d3c07f9cc71ff8c231d43391bcf73480c7ecb34d3625d4cf3089a3"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538c1ab7e7ec122356ed1e6e7ff6d9ad5feafa4a9ab5b82f84a01efc48a2c2ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "538c1ab7e7ec122356ed1e6e7ff6d9ad5feafa4a9ab5b82f84a01efc48a2c2ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "538c1ab7e7ec122356ed1e6e7ff6d9ad5feafa4a9ab5b82f84a01efc48a2c2ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "39a99cfc940182f7ef5ca7800851f889a311a2940d1ad8965e9ea6a172cee020"
    sha256 cellar: :any_skip_relocation, ventura:       "39a99cfc940182f7ef5ca7800851f889a311a2940d1ad8965e9ea6a172cee020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72882d00899d96d85c1841b001b18665c759b8faa4eae5bd66af4707fe709791"
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