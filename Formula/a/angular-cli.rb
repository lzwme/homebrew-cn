require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.2.tgz"
  sha256 "27ebad8be5d886e40bf7c3a6c21ca0c84d0b07994a41348fee2f50c88701c9b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08e506b361c5e5748cb1a24a477164d28878bbbff1ce88b33d1ad2eac1ff5dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08e506b361c5e5748cb1a24a477164d28878bbbff1ce88b33d1ad2eac1ff5dcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08e506b361c5e5748cb1a24a477164d28878bbbff1ce88b33d1ad2eac1ff5dcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "31ffb46bb72ba59cfad1981087eacc9d7b893ee8169cc48d657c50cad50773a2"
    sha256 cellar: :any_skip_relocation, ventura:        "31ffb46bb72ba59cfad1981087eacc9d7b893ee8169cc48d657c50cad50773a2"
    sha256 cellar: :any_skip_relocation, monterey:       "31ffb46bb72ba59cfad1981087eacc9d7b893ee8169cc48d657c50cad50773a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08e506b361c5e5748cb1a24a477164d28878bbbff1ce88b33d1ad2eac1ff5dcb"
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