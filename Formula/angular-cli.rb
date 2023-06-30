require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.3.tgz"
  sha256 "1d0af05445be6a639de958304c44ee8a06e5a0993383486c76d2b6fa16b493ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0025233c3568b704f8bbc34aec70aefd2f9fead731a371445251f7f5462d0dce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0025233c3568b704f8bbc34aec70aefd2f9fead731a371445251f7f5462d0dce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0025233c3568b704f8bbc34aec70aefd2f9fead731a371445251f7f5462d0dce"
    sha256 cellar: :any_skip_relocation, ventura:        "a2619dc06b9de971f583437267904e8b73a6fd83cf86b6ca792cb399a8713af2"
    sha256 cellar: :any_skip_relocation, monterey:       "a2619dc06b9de971f583437267904e8b73a6fd83cf86b6ca792cb399a8713af2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2619dc06b9de971f583437267904e8b73a6fd83cf86b6ca792cb399a8713af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0025233c3568b704f8bbc34aec70aefd2f9fead731a371445251f7f5462d0dce"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end