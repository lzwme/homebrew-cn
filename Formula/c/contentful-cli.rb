require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.15.tgz"
  sha256 "0a5a0a05c6529383db5db063de23ea6331f2fd36cad3754e1191a703e9d9ee84"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c24046361368d8d8195e7eed6c17c99331be7b439149bc6787a481ec2cbc297"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c24046361368d8d8195e7eed6c17c99331be7b439149bc6787a481ec2cbc297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c24046361368d8d8195e7eed6c17c99331be7b439149bc6787a481ec2cbc297"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4e12002ef196b25d59d07ae5c70c3797ce3478310ad6f1023601cb26a3f0553"
    sha256 cellar: :any_skip_relocation, ventura:        "d4e12002ef196b25d59d07ae5c70c3797ce3478310ad6f1023601cb26a3f0553"
    sha256 cellar: :any_skip_relocation, monterey:       "d4e12002ef196b25d59d07ae5c70c3797ce3478310ad6f1023601cb26a3f0553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c24046361368d8d8195e7eed6c17c99331be7b439149bc6787a481ec2cbc297"
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