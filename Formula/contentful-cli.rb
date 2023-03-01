require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.1.0.tgz"
  sha256 "b851ba2545a43cc7660d819fddbf0902b82d3c8713a8be9c6e3d8266440e7646"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c259216ba34ef868fd0aaa32131ddd793d4d346a1cd881fca35aa52808b53ae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c259216ba34ef868fd0aaa32131ddd793d4d346a1cd881fca35aa52808b53ae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c259216ba34ef868fd0aaa32131ddd793d4d346a1cd881fca35aa52808b53ae7"
    sha256 cellar: :any_skip_relocation, ventura:        "35264548010acdbefbf1851a0d8924034c924258f4c87cc0b8d5c480c76d0036"
    sha256 cellar: :any_skip_relocation, monterey:       "35264548010acdbefbf1851a0d8924034c924258f4c87cc0b8d5c480c76d0036"
    sha256 cellar: :any_skip_relocation, big_sur:        "35264548010acdbefbf1851a0d8924034c924258f4c87cc0b8d5c480c76d0036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c259216ba34ef868fd0aaa32131ddd793d4d346a1cd881fca35aa52808b53ae7"
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