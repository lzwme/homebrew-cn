require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.28.tgz"
  sha256 "c80e742bf014f67ff3c33e64c1b8f543da5ef7699724988af0aa4a2592bdf6c9"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1fe04b696900b61fe01c8b429d7dec2131f1d345b236dfaea63394a0d7aef70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1fe04b696900b61fe01c8b429d7dec2131f1d345b236dfaea63394a0d7aef70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1fe04b696900b61fe01c8b429d7dec2131f1d345b236dfaea63394a0d7aef70"
    sha256 cellar: :any_skip_relocation, sonoma:         "7df9657149e0a8a4e8547b95cb03a6179c8b55306d461d16f12417de1b8e6214"
    sha256 cellar: :any_skip_relocation, ventura:        "7df9657149e0a8a4e8547b95cb03a6179c8b55306d461d16f12417de1b8e6214"
    sha256 cellar: :any_skip_relocation, monterey:       "7df9657149e0a8a4e8547b95cb03a6179c8b55306d461d16f12417de1b8e6214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1fe04b696900b61fe01c8b429d7dec2131f1d345b236dfaea63394a0d7aef70"
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