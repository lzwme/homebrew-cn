require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.23.tgz"
  sha256 "085529f8d2c954cb2b3078a7cf069e9bdc22aff88336b0285354d1da69efc239"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f78c5f14d8afb65abb72937a3b58e5a9ad359fe80bee70f5fba39489bc5e79db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78c5f14d8afb65abb72937a3b58e5a9ad359fe80bee70f5fba39489bc5e79db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f78c5f14d8afb65abb72937a3b58e5a9ad359fe80bee70f5fba39489bc5e79db"
    sha256 cellar: :any_skip_relocation, ventura:        "f859329478a4f40719fc56cb6f4117110ad9858c1f91f83d81e5d77e7b78a743"
    sha256 cellar: :any_skip_relocation, monterey:       "f859329478a4f40719fc56cb6f4117110ad9858c1f91f83d81e5d77e7b78a743"
    sha256 cellar: :any_skip_relocation, big_sur:        "f859329478a4f40719fc56cb6f4117110ad9858c1f91f83d81e5d77e7b78a743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78c5f14d8afb65abb72937a3b58e5a9ad359fe80bee70f5fba39489bc5e79db"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end