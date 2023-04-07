require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.3.0.tgz"
  sha256 "83e989c9bbfc4b25fd0560840c756aeb67c358116e1eac9f9897c70d3b75a6a5"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60d0febfa9fd4f50aabe48bd40725d5cf1c1cf6039d79c1dfcd7774f6d477914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d0febfa9fd4f50aabe48bd40725d5cf1c1cf6039d79c1dfcd7774f6d477914"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d0febfa9fd4f50aabe48bd40725d5cf1c1cf6039d79c1dfcd7774f6d477914"
    sha256 cellar: :any_skip_relocation, ventura:        "871073344447e46b0b7401726a5fe3ad613cca1b7b8906ac997d089372a2ce15"
    sha256 cellar: :any_skip_relocation, monterey:       "871073344447e46b0b7401726a5fe3ad613cca1b7b8906ac997d089372a2ce15"
    sha256 cellar: :any_skip_relocation, big_sur:        "871073344447e46b0b7401726a5fe3ad613cca1b7b8906ac997d089372a2ce15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d0febfa9fd4f50aabe48bd40725d5cf1c1cf6039d79c1dfcd7774f6d477914"
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