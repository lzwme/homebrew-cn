require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.2.0.tgz"
  sha256 "e7cea80403a3af62c7369d0d9b7df263bbaa6e0bee24f41c8fb61a93d99d1933"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a549b7acc1e34c7bb178a14df721384940efc3ae10bc64ae2551add3990f1360"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a549b7acc1e34c7bb178a14df721384940efc3ae10bc64ae2551add3990f1360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a549b7acc1e34c7bb178a14df721384940efc3ae10bc64ae2551add3990f1360"
    sha256 cellar: :any_skip_relocation, sonoma:         "df9149efe2a7a973a3dc0b0eb2dd3d1f21cd064bec1cbddac6d07ccc5c28fee8"
    sha256 cellar: :any_skip_relocation, ventura:        "df9149efe2a7a973a3dc0b0eb2dd3d1f21cd064bec1cbddac6d07ccc5c28fee8"
    sha256 cellar: :any_skip_relocation, monterey:       "df9149efe2a7a973a3dc0b0eb2dd3d1f21cd064bec1cbddac6d07ccc5c28fee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a549b7acc1e34c7bb178a14df721384940efc3ae10bc64ae2551add3990f1360"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end