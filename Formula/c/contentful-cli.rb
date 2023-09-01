require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.0.tgz"
  sha256 "88059fe2c2afa95a292f165df4f2dc8886d334a9944135034f66fde620c936b8"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ebf0f56360f870f5c3a78db80b9d6b3f6f9899d9fdae9f39bc6251f1f130306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ebf0f56360f870f5c3a78db80b9d6b3f6f9899d9fdae9f39bc6251f1f130306"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ebf0f56360f870f5c3a78db80b9d6b3f6f9899d9fdae9f39bc6251f1f130306"
    sha256 cellar: :any_skip_relocation, ventura:        "f71ae8b5f334f880918a528e589881c2e49b74e5791416206b74788668a09289"
    sha256 cellar: :any_skip_relocation, monterey:       "f71ae8b5f334f880918a528e589881c2e49b74e5791416206b74788668a09289"
    sha256 cellar: :any_skip_relocation, big_sur:        "f71ae8b5f334f880918a528e589881c2e49b74e5791416206b74788668a09289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ebf0f56360f870f5c3a78db80b9d6b3f6f9899d9fdae9f39bc6251f1f130306"
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