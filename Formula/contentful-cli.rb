require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.2.20.tgz"
  sha256 "ea07f7c33ca907323d9bfd80f19afdcd5fb38e588d5d0b4857326f3175bffc91"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7427df190c2eeb0e9467819b63c459d6d4b298dd0f77f2f7317a28e71539e60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7427df190c2eeb0e9467819b63c459d6d4b298dd0f77f2f7317a28e71539e60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7427df190c2eeb0e9467819b63c459d6d4b298dd0f77f2f7317a28e71539e60"
    sha256 cellar: :any_skip_relocation, ventura:        "aa0862ad83c4a63b7b5fc176bd4f214707085f9bc8ef88aa2239c1305636666e"
    sha256 cellar: :any_skip_relocation, monterey:       "aa0862ad83c4a63b7b5fc176bd4f214707085f9bc8ef88aa2239c1305636666e"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa0862ad83c4a63b7b5fc176bd4f214707085f9bc8ef88aa2239c1305636666e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7427df190c2eeb0e9467819b63c459d6d4b298dd0f77f2f7317a28e71539e60"
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