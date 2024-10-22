class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.21.tgz"
  sha256 "9103eb3212965bf5f3b6d889d8b4ed71ab76a04fb7afbbb50de7d034ba480414"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2f87150d666db00cfc69456e7b9627a6be15bf5d13879caec83b579673d84b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c2f87150d666db00cfc69456e7b9627a6be15bf5d13879caec83b579673d84b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c2f87150d666db00cfc69456e7b9627a6be15bf5d13879caec83b579673d84b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b88cecf5d590248b4ce74f9217db574d9935de085ca7c57e091b71915b693be"
    sha256 cellar: :any_skip_relocation, ventura:       "6b88cecf5d590248b4ce74f9217db574d9935de085ca7c57e091b71915b693be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c2f87150d666db00cfc69456e7b9627a6be15bf5d13879caec83b579673d84b"
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