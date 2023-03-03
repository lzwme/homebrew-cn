require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.1.tgz"
  sha256 "9c23ae4bdc8133c72f272e2c2e742c856ad2531735f1f5113f19cbb392da1ee9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bbba005bc9f6a794eb310e3a5a7eb7038cfc58aff06f62f5132db14e7e29e4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bbba005bc9f6a794eb310e3a5a7eb7038cfc58aff06f62f5132db14e7e29e4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bbba005bc9f6a794eb310e3a5a7eb7038cfc58aff06f62f5132db14e7e29e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "e31bcad1803314d34970e32a05a234a8e540d567b0fd959b8ea693c98fffd336"
    sha256 cellar: :any_skip_relocation, monterey:       "e31bcad1803314d34970e32a05a234a8e540d567b0fd959b8ea693c98fffd336"
    sha256 cellar: :any_skip_relocation, big_sur:        "e31bcad1803314d34970e32a05a234a8e540d567b0fd959b8ea693c98fffd336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bbba005bc9f6a794eb310e3a5a7eb7038cfc58aff06f62f5132db14e7e29e4a"
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