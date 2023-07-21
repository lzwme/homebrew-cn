require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.5.tgz"
  sha256 "50cf2ee4996104a4f144fdc6381b018a073820621423bd8a028b2a303b6ddb07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83b6565016cbd541832ce9904ba55f914e4460d170d472e62c36c0ed49de4162"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b6565016cbd541832ce9904ba55f914e4460d170d472e62c36c0ed49de4162"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83b6565016cbd541832ce9904ba55f914e4460d170d472e62c36c0ed49de4162"
    sha256 cellar: :any_skip_relocation, ventura:        "56df55c8f1be2b8052c79b9682f8e36857c77add3b742a79206fd8253c95a1e9"
    sha256 cellar: :any_skip_relocation, monterey:       "56df55c8f1be2b8052c79b9682f8e36857c77add3b742a79206fd8253c95a1e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "56df55c8f1be2b8052c79b9682f8e36857c77add3b742a79206fd8253c95a1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0141d15595662e2c1c757377a178f4b174bbdc2f2e5af629c7e4bfed4dfa058a"
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