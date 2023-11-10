require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.14.tgz"
  sha256 "e3672c3a172568991d3e25f5796bffe1bd946b51a249621262cbfd75be7249ca"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8737ff65587707be791666e0e613c4f9485d78319661420b130839a211d68a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8737ff65587707be791666e0e613c4f9485d78319661420b130839a211d68a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8737ff65587707be791666e0e613c4f9485d78319661420b130839a211d68a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "31b6c5add70702d162f6970fe7d5098f5c260e7b5e27a409248c6ce0ad215acc"
    sha256 cellar: :any_skip_relocation, ventura:        "31b6c5add70702d162f6970fe7d5098f5c260e7b5e27a409248c6ce0ad215acc"
    sha256 cellar: :any_skip_relocation, monterey:       "31b6c5add70702d162f6970fe7d5098f5c260e7b5e27a409248c6ce0ad215acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8737ff65587707be791666e0e613c4f9485d78319661420b130839a211d68a9"
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