require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.5.0.tgz"
  sha256 "25173e768f25d4016fe9b939b0c03d2a98e4672cf1a9922d65ec972a4802cdee"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e13ace5673aa6f14da0f88ea0b50f492e07b60c61fbaea9d2eb93923bb9a879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e13ace5673aa6f14da0f88ea0b50f492e07b60c61fbaea9d2eb93923bb9a879"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e13ace5673aa6f14da0f88ea0b50f492e07b60c61fbaea9d2eb93923bb9a879"
    sha256 cellar: :any_skip_relocation, ventura:        "b8c746751d01e20e7007e958b32b6c91130e227a77a4e9b250a361a5e0a372e6"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c746751d01e20e7007e958b32b6c91130e227a77a4e9b250a361a5e0a372e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8c746751d01e20e7007e958b32b6c91130e227a77a4e9b250a361a5e0a372e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e13ace5673aa6f14da0f88ea0b50f492e07b60c61fbaea9d2eb93923bb9a879"
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