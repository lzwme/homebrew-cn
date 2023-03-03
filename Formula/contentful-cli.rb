require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.1.5.tgz"
  sha256 "b78d9ad066495f93ba563ff056a857f736b11224c5bbe752ebf7e8c91532ffb4"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "259e2b41976fdd49ba1f269858348b6b95706489495c1ff223a5a2a7736d9edc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "259e2b41976fdd49ba1f269858348b6b95706489495c1ff223a5a2a7736d9edc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "259e2b41976fdd49ba1f269858348b6b95706489495c1ff223a5a2a7736d9edc"
    sha256 cellar: :any_skip_relocation, ventura:        "2f7a798b993c50ead747a800c235f23d9d93347aba8ccfec96c96790a255a94b"
    sha256 cellar: :any_skip_relocation, monterey:       "2f7a798b993c50ead747a800c235f23d9d93347aba8ccfec96c96790a255a94b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f7a798b993c50ead747a800c235f23d9d93347aba8ccfec96c96790a255a94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "259e2b41976fdd49ba1f269858348b6b95706489495c1ff223a5a2a7736d9edc"
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