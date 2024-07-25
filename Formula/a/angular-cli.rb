require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.1.2.tgz"
  sha256 "4ac6bb38cf842a58bebc5d4ab960d8306e45443ebc97aba1f6526a7532c59c5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4acc45b3b23ac03ade5aba14e5013df8e1b2fc110ae74af8e2adf41d351f8836"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4acc45b3b23ac03ade5aba14e5013df8e1b2fc110ae74af8e2adf41d351f8836"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4acc45b3b23ac03ade5aba14e5013df8e1b2fc110ae74af8e2adf41d351f8836"
    sha256 cellar: :any_skip_relocation, sonoma:         "2993f7f4f03ccbbe08e3146683ed534974086f4d572cab647554bdb2b7ee72cf"
    sha256 cellar: :any_skip_relocation, ventura:        "2993f7f4f03ccbbe08e3146683ed534974086f4d572cab647554bdb2b7ee72cf"
    sha256 cellar: :any_skip_relocation, monterey:       "2993f7f4f03ccbbe08e3146683ed534974086f4d572cab647554bdb2b7ee72cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "378f8747dadfa93d0592928517366e9ed5decfcd765d95fab84136bfd9e7a059"
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