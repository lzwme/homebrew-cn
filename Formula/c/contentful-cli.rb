require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.9.tgz"
  sha256 "7ebbe9dc76e9892fd7b751d3912c8a3b76320c491124b57dcfcac799b36da503"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d22337be6b33e3eb22d0fba9d1c1304b504f1e6b132121f31ffefbd01ad694"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d22337be6b33e3eb22d0fba9d1c1304b504f1e6b132121f31ffefbd01ad694"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37d22337be6b33e3eb22d0fba9d1c1304b504f1e6b132121f31ffefbd01ad694"
    sha256 cellar: :any_skip_relocation, ventura:        "a7e97732480b7e619002ecc07ff0168a198f03eaafe2f8b646044bb00055d4bb"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e97732480b7e619002ecc07ff0168a198f03eaafe2f8b646044bb00055d4bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7e97732480b7e619002ecc07ff0168a198f03eaafe2f8b646044bb00055d4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d22337be6b33e3eb22d0fba9d1c1304b504f1e6b132121f31ffefbd01ad694"
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