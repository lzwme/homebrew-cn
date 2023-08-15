require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.38.0.tgz"
  sha256 "a59b54273d6f51eb5204a34dc68fd10e61d2fc8284876f17e560dbc2fd63aea1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da04bc0a68389ca9fc8b1384e34faa9c571fe10facad04174b9d9a7e4fe68b38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da04bc0a68389ca9fc8b1384e34faa9c571fe10facad04174b9d9a7e4fe68b38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da04bc0a68389ca9fc8b1384e34faa9c571fe10facad04174b9d9a7e4fe68b38"
    sha256 cellar: :any_skip_relocation, ventura:        "1fd9d3010f051d19badd9b2cdb0356d6f29993624c3fa7f2d9029e942d13f874"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd9d3010f051d19badd9b2cdb0356d6f29993624c3fa7f2d9029e942d13f874"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fd9d3010f051d19badd9b2cdb0356d6f29993624c3fa7f2d9029e942d13f874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da04bc0a68389ca9fc8b1384e34faa9c571fe10facad04174b9d9a7e4fe68b38"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end