require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.16.tgz"
  sha256 "b1d5e66cda69fbc07e3dbd586fb56fe86007f7e9180541d666f396a961b857ea"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e47f90d0900f0e39c49ceeeeb3f62e658320f511b64e7fb418db00bf3ad79d15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e47f90d0900f0e39c49ceeeeb3f62e658320f511b64e7fb418db00bf3ad79d15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e47f90d0900f0e39c49ceeeeb3f62e658320f511b64e7fb418db00bf3ad79d15"
    sha256 cellar: :any_skip_relocation, sonoma:         "238b6dc5b23c21ecd6dd8dfa5c28334afbc5a1ebf4ac741823b0d64fa7970273"
    sha256 cellar: :any_skip_relocation, ventura:        "238b6dc5b23c21ecd6dd8dfa5c28334afbc5a1ebf4ac741823b0d64fa7970273"
    sha256 cellar: :any_skip_relocation, monterey:       "238b6dc5b23c21ecd6dd8dfa5c28334afbc5a1ebf4ac741823b0d64fa7970273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e47f90d0900f0e39c49ceeeeb3f62e658320f511b64e7fb418db00bf3ad79d15"
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