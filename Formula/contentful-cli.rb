require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.31.tgz"
  sha256 "dca2cdb221687cec11d32744ea79c3de6962a6d71cda2fad897aa8f8b2b14e11"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5264c439c1364b9ade762bf33372bdbeaa8851c8d97dcc549fd0ccd2b3d31212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5264c439c1364b9ade762bf33372bdbeaa8851c8d97dcc549fd0ccd2b3d31212"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5264c439c1364b9ade762bf33372bdbeaa8851c8d97dcc549fd0ccd2b3d31212"
    sha256 cellar: :any_skip_relocation, ventura:        "688bef505c7fc0c40c717194e8fba6c103e0aa92b5c0479a1d88dce4e80ed4c7"
    sha256 cellar: :any_skip_relocation, monterey:       "688bef505c7fc0c40c717194e8fba6c103e0aa92b5c0479a1d88dce4e80ed4c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "688bef505c7fc0c40c717194e8fba6c103e0aa92b5c0479a1d88dce4e80ed4c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "049a00a9d21d6f2e502e1a8f8e93b7f93aa25bfcf5cb300bba3bb5fd5790b7ed"
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