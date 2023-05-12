require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.5.tgz"
  sha256 "2119a9e82f4da71ebe64b8e8f10eb38bd62d63224b72131ea8fcb407a2304dc3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de6eb4dcffe94141fdfe4df61718e1da8c92d5f19b01439a56d2de89464c353b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de6eb4dcffe94141fdfe4df61718e1da8c92d5f19b01439a56d2de89464c353b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de6eb4dcffe94141fdfe4df61718e1da8c92d5f19b01439a56d2de89464c353b"
    sha256 cellar: :any_skip_relocation, ventura:        "8ff1cec829c2a3f3a50cf011314fe23a02484141ba5d05265505f15b987b027c"
    sha256 cellar: :any_skip_relocation, monterey:       "8ff1cec829c2a3f3a50cf011314fe23a02484141ba5d05265505f15b987b027c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ff1cec829c2a3f3a50cf011314fe23a02484141ba5d05265505f15b987b027c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de6eb4dcffe94141fdfe4df61718e1da8c92d5f19b01439a56d2de89464c353b"
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