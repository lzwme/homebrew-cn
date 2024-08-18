class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.191.tgz"
  sha256 "22a1e15fa44718cb93b89a383a344d6018c8d3d1d985b78ebbd1898cf8638a3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8fc75a12513ddaa8a16146e83f0f2127795032f3c04a672b134a59f5b89ba4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8fc75a12513ddaa8a16146e83f0f2127795032f3c04a672b134a59f5b89ba4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8fc75a12513ddaa8a16146e83f0f2127795032f3c04a672b134a59f5b89ba4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1900befd33dde53cc35ba0b5f3cbc571d4d512da27c4270d276d8d41edb20207"
    sha256 cellar: :any_skip_relocation, ventura:        "1900befd33dde53cc35ba0b5f3cbc571d4d512da27c4270d276d8d41edb20207"
    sha256 cellar: :any_skip_relocation, monterey:       "1900befd33dde53cc35ba0b5f3cbc571d4d512da27c4270d276d8d41edb20207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8fc75a12513ddaa8a16146e83f0f2127795032f3c04a672b134a59f5b89ba4b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end