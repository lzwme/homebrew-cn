class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.12.tgz"
  sha256 "7eea8c9c44c61a57e9bc4f195d0c9cc2c6b7013d8d06b849ebef5d45256a5620"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63998a2e30669108529ada9781cdafde568402ad583dd92f7cefd0a07796cd9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63998a2e30669108529ada9781cdafde568402ad583dd92f7cefd0a07796cd9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63998a2e30669108529ada9781cdafde568402ad583dd92f7cefd0a07796cd9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a36091abd8b27388ba375dcc53456b9b41cd09ede956d8d3e0279e97b725b6ad"
    sha256 cellar: :any_skip_relocation, ventura:       "a36091abd8b27388ba375dcc53456b9b41cd09ede956d8d3e0279e97b725b6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b1a45f197c87450acb5176762733edb9818ba0b4bdf8f0656de3db2a1cd3a3"
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