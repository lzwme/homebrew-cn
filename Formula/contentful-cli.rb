require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.15.tgz"
  sha256 "d7a8dc2a7cb86aa20a1267f2b697600654e75949232b2f3b01d4a7a68a29e1a0"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45fec2db3ba93ef744295b6038b0ad6cfbd22e8c26ff9735b3f6c832fe3e85fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45fec2db3ba93ef744295b6038b0ad6cfbd22e8c26ff9735b3f6c832fe3e85fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45fec2db3ba93ef744295b6038b0ad6cfbd22e8c26ff9735b3f6c832fe3e85fe"
    sha256 cellar: :any_skip_relocation, ventura:        "ddcb800dc5b469cdfc9e92c0e2708d23b4c31f17e00a5c35497e9855bd1d7c22"
    sha256 cellar: :any_skip_relocation, monterey:       "ddcb800dc5b469cdfc9e92c0e2708d23b4c31f17e00a5c35497e9855bd1d7c22"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddcb800dc5b469cdfc9e92c0e2708d23b4c31f17e00a5c35497e9855bd1d7c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45fec2db3ba93ef744295b6038b0ad6cfbd22e8c26ff9735b3f6c832fe3e85fe"
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