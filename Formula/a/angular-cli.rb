require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.2.tgz"
  sha256 "34f6acd638f9b2d7c69e31ba0c7877f5b9ef7b5acf5d83b381f280d889bc1d8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09d9094b7994d343cd1b8e637bfe99fc0a7c0f72e921e5ea0a337ddb0285fc41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09d9094b7994d343cd1b8e637bfe99fc0a7c0f72e921e5ea0a337ddb0285fc41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09d9094b7994d343cd1b8e637bfe99fc0a7c0f72e921e5ea0a337ddb0285fc41"
    sha256 cellar: :any_skip_relocation, ventura:        "70a08a23dd420a0a3eba6bcdd8c2cdd58ea1d6a970a7c5c6af0c2c6477ec396b"
    sha256 cellar: :any_skip_relocation, monterey:       "70a08a23dd420a0a3eba6bcdd8c2cdd58ea1d6a970a7c5c6af0c2c6477ec396b"
    sha256 cellar: :any_skip_relocation, big_sur:        "70a08a23dd420a0a3eba6bcdd8c2cdd58ea1d6a970a7c5c6af0c2c6477ec396b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d9094b7994d343cd1b8e637bfe99fc0a7c0f72e921e5ea0a337ddb0285fc41"
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