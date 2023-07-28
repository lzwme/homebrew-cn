require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.6.tgz"
  sha256 "9d4ed1b98bc94102da782b3b8ad0290fd63fe80fe5043ab10f287b2820b562aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd6b4e60468967eda39cab1446a79f1078bfef9c69f612d647782520750d076a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd6b4e60468967eda39cab1446a79f1078bfef9c69f612d647782520750d076a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd6b4e60468967eda39cab1446a79f1078bfef9c69f612d647782520750d076a"
    sha256 cellar: :any_skip_relocation, ventura:        "5a9dbb5e8378da6c330a0db48bc51a8d3baaf5b2a26b6ab597776c30340e134f"
    sha256 cellar: :any_skip_relocation, monterey:       "5a9dbb5e8378da6c330a0db48bc51a8d3baaf5b2a26b6ab597776c30340e134f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a9dbb5e8378da6c330a0db48bc51a8d3baaf5b2a26b6ab597776c30340e134f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5702bd22f7790631a714df10c42cd404d6c785c9c4df87b3b4c7cc2d6f87f7c3"
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