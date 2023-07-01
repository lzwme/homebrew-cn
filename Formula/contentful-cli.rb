require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.24.tgz"
  sha256 "2e845c100806e33533f806d52c2215b497a080cf6d2d964af3aff8c46c7de426"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a35f6368f76194e7f63f8750750b727de99fac61ffa30ef425eb53693ff3316b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a35f6368f76194e7f63f8750750b727de99fac61ffa30ef425eb53693ff3316b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a35f6368f76194e7f63f8750750b727de99fac61ffa30ef425eb53693ff3316b"
    sha256 cellar: :any_skip_relocation, ventura:        "d112845bb01bb0b511553430621620b0d4e83f7879dc8b62a507add03a5a63bb"
    sha256 cellar: :any_skip_relocation, monterey:       "d112845bb01bb0b511553430621620b0d4e83f7879dc8b62a507add03a5a63bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d112845bb01bb0b511553430621620b0d4e83f7879dc8b62a507add03a5a63bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a35f6368f76194e7f63f8750750b727de99fac61ffa30ef425eb53693ff3316b"
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