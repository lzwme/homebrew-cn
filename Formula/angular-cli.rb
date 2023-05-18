require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.0.2.tgz"
  sha256 "18e364344dc09d9cd5433f9448d9e9716b65155e9a72c6745d966a213f9e0c09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00ff933e81808ea9df5e8d84e66f50d495089ef3424bc68ee0d2018bcfe55296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00ff933e81808ea9df5e8d84e66f50d495089ef3424bc68ee0d2018bcfe55296"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00ff933e81808ea9df5e8d84e66f50d495089ef3424bc68ee0d2018bcfe55296"
    sha256 cellar: :any_skip_relocation, ventura:        "45c84fed902f97e0f20b950976f4cb217b9e088c45207f91d4f7269be45714c9"
    sha256 cellar: :any_skip_relocation, monterey:       "45c84fed902f97e0f20b950976f4cb217b9e088c45207f91d4f7269be45714c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "45c84fed902f97e0f20b950976f4cb217b9e088c45207f91d4f7269be45714c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00ff933e81808ea9df5e8d84e66f50d495089ef3424bc68ee0d2018bcfe55296"
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