class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.5.6.tgz"
  sha256 "f67130f1735c7c6fc1d8169729b19c146da87da4c664acb6809bd874f4a167d4"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f517ef8f87980f7e8c86fa4e546531a2f0447468867451596f592513b27a229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f517ef8f87980f7e8c86fa4e546531a2f0447468867451596f592513b27a229"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f517ef8f87980f7e8c86fa4e546531a2f0447468867451596f592513b27a229"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae4e0a2ce86d5ad451a2d06337a1d58282db21e113157fb772e41e6a8417c271"
    sha256 cellar: :any_skip_relocation, ventura:       "ae4e0a2ce86d5ad451a2d06337a1d58282db21e113157fb772e41e6a8417c271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f517ef8f87980f7e8c86fa4e546531a2f0447468867451596f592513b27a229"
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