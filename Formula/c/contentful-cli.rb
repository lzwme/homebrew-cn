require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.8.tgz"
  sha256 "b1b4c696a811b08c5f17a5214b005c5be4cb93790beb95d6cc2cff7f2d7224db"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41e74c9cf02a422233db4948d05897daf8b90eb7626529223341b262e5c926fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41e74c9cf02a422233db4948d05897daf8b90eb7626529223341b262e5c926fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41e74c9cf02a422233db4948d05897daf8b90eb7626529223341b262e5c926fa"
    sha256 cellar: :any_skip_relocation, ventura:        "732207e798caad77e8a68ea907b7afcd957f19ee239ac96e544962d112cc1bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "732207e798caad77e8a68ea907b7afcd957f19ee239ac96e544962d112cc1bbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "732207e798caad77e8a68ea907b7afcd957f19ee239ac96e544962d112cc1bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41e74c9cf02a422233db4948d05897daf8b90eb7626529223341b262e5c926fa"
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