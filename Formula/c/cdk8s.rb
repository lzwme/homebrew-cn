require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.95.0.tgz"
  sha256 "8429b98c28999d446ce68b5f949027d1fe7a47dbd2329183f82e8e4d1ba2d0c5"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "542d7c082d1551487720d42a629476d36ccf2dec7fa2aa4de57c4d927fb5b14e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "542d7c082d1551487720d42a629476d36ccf2dec7fa2aa4de57c4d927fb5b14e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "542d7c082d1551487720d42a629476d36ccf2dec7fa2aa4de57c4d927fb5b14e"
    sha256 cellar: :any_skip_relocation, ventura:        "7d54530d4bea2867b8ad5a4fe60c9a092f0f3684c2dca08d0778a4ace9d4b272"
    sha256 cellar: :any_skip_relocation, monterey:       "644a0a05187fab5b4c69b32e8f55ccf99e7eb038734be28b1780d8f13d7e271b"
    sha256 cellar: :any_skip_relocation, big_sur:        "644a0a05187fab5b4c69b32e8f55ccf99e7eb038734be28b1780d8f13d7e271b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542d7c082d1551487720d42a629476d36ccf2dec7fa2aa4de57c4d927fb5b14e"
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