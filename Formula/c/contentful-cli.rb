require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.1.30.tgz"
  sha256 "f7215dbac25c2cbceb0f7ca2e7ef088b7868e95bd371f13ecd9d735e4b3ce9f0"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "456173344c95717ca8cd9025dd4adbd3070cd1dbaa9ceccd90d35bb7fb23cece"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "456173344c95717ca8cd9025dd4adbd3070cd1dbaa9ceccd90d35bb7fb23cece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "456173344c95717ca8cd9025dd4adbd3070cd1dbaa9ceccd90d35bb7fb23cece"
    sha256 cellar: :any_skip_relocation, sonoma:         "e14901f471c47d37cfe3304123105122567c328804f082cf991172014facde5d"
    sha256 cellar: :any_skip_relocation, ventura:        "e14901f471c47d37cfe3304123105122567c328804f082cf991172014facde5d"
    sha256 cellar: :any_skip_relocation, monterey:       "e14901f471c47d37cfe3304123105122567c328804f082cf991172014facde5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "456173344c95717ca8cd9025dd4adbd3070cd1dbaa9ceccd90d35bb7fb23cece"
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