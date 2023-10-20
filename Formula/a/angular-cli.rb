require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.7.tgz"
  sha256 "b139435cb4215d1da0ed612bd864d36064fa83a3101425b143a341d252bd6a53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90aed940c89a34c5b40f25213c0fc981eee22922136c44d3d19951af9a09a3bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90aed940c89a34c5b40f25213c0fc981eee22922136c44d3d19951af9a09a3bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90aed940c89a34c5b40f25213c0fc981eee22922136c44d3d19951af9a09a3bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2ee8e0ce14fe84685e0b68fc43a1758e16b7a5bdbd50f1bb0024170f7d5e283"
    sha256 cellar: :any_skip_relocation, ventura:        "b2ee8e0ce14fe84685e0b68fc43a1758e16b7a5bdbd50f1bb0024170f7d5e283"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ee8e0ce14fe84685e0b68fc43a1758e16b7a5bdbd50f1bb0024170f7d5e283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90aed940c89a34c5b40f25213c0fc981eee22922136c44d3d19951af9a09a3bd"
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