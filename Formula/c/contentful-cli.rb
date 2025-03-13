class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.13.tgz"
  sha256 "d12b65a70e80de274a4f44e27776166c4d4b2e0985e754dfb7d21ac1de3dbeb0"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2cb5bd119b805cd01887a4a6b2d35dbc1ab8e8477620b224029dfd11448f79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a2cb5bd119b805cd01887a4a6b2d35dbc1ab8e8477620b224029dfd11448f79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a2cb5bd119b805cd01887a4a6b2d35dbc1ab8e8477620b224029dfd11448f79"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b67c357b1a3818194f110a0a328f119320b8e7228c940532a8bb042b1882ff1"
    sha256 cellar: :any_skip_relocation, ventura:       "1b67c357b1a3818194f110a0a328f119320b8e7228c940532a8bb042b1882ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1924d89853c5f041744ec4f108730067600bd38df692e3f9402ab8ed5de51ae2"
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