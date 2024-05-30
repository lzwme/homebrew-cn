require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.0.2.tgz"
  sha256 "d0f6b758b005f74be5dc4192aa2f3db1aaabb0093ebea9b0541767315930b849"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de13d2ce79ac5040b85ae8f086eed8b2b7967b7f5540c02c66871b3ab7ee33b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de13d2ce79ac5040b85ae8f086eed8b2b7967b7f5540c02c66871b3ab7ee33b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de13d2ce79ac5040b85ae8f086eed8b2b7967b7f5540c02c66871b3ab7ee33b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "06ac461917f799b11cb09372b1c71be979ada415d10a9dd0f77b8d7f80890dce"
    sha256 cellar: :any_skip_relocation, ventura:        "06ac461917f799b11cb09372b1c71be979ada415d10a9dd0f77b8d7f80890dce"
    sha256 cellar: :any_skip_relocation, monterey:       "69575834e0c8ab3146c0c092918c74cb5b5212bf505881ebd275e1523544008d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb0cf1c937e3b3e435f3b43c9331ce2c71cf9e45723db9126bdf6e16d0b32c9"
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