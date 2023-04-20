require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.14.tgz"
  sha256 "9e51c3860f77780d76a0e3d9faad1c051cc7e14e002c12dc6107e45b0be3a2cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3219662c85e91456f5011e806aa298b4debc31be51eb2af9e7ea767577a8f820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3219662c85e91456f5011e806aa298b4debc31be51eb2af9e7ea767577a8f820"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3219662c85e91456f5011e806aa298b4debc31be51eb2af9e7ea767577a8f820"
    sha256 cellar: :any_skip_relocation, ventura:        "d588a8381ad7d61ee028049c090749f7ba0528147a70e8d331e42dc62ca84572"
    sha256 cellar: :any_skip_relocation, monterey:       "d588a8381ad7d61ee028049c090749f7ba0528147a70e8d331e42dc62ca84572"
    sha256 cellar: :any_skip_relocation, big_sur:        "d588a8381ad7d61ee028049c090749f7ba0528147a70e8d331e42dc62ca84572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3219662c85e91456f5011e806aa298b4debc31be51eb2af9e7ea767577a8f820"
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