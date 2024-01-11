require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.10.tgz"
  sha256 "48fb80d65f5bda85f4695a8a35e0eafc2a60f3cfa28889fb54bcee30e944e5c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dfcf84b5331adbc9fc3cd8f855ef7ff5105bc25378373b0cd5c3195220cfd11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dfcf84b5331adbc9fc3cd8f855ef7ff5105bc25378373b0cd5c3195220cfd11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dfcf84b5331adbc9fc3cd8f855ef7ff5105bc25378373b0cd5c3195220cfd11"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ae47907cc72375f3ef3f5d289aaacd6daf435a96f23fc9cff7f5a757284718f"
    sha256 cellar: :any_skip_relocation, ventura:        "9ae47907cc72375f3ef3f5d289aaacd6daf435a96f23fc9cff7f5a757284718f"
    sha256 cellar: :any_skip_relocation, monterey:       "9ae47907cc72375f3ef3f5d289aaacd6daf435a96f23fc9cff7f5a757284718f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dfcf84b5331adbc9fc3cd8f855ef7ff5105bc25378373b0cd5c3195220cfd11"
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