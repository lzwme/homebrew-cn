class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.146.tgz"
  sha256 "94f9eb69ddd64d550f2f0ac4887f0096d927acee7ebe868d28b136aabd535c17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f51802e20b196c281ec6e9fe54d5dcb340732238c235be881418b171b75ba785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f51802e20b196c281ec6e9fe54d5dcb340732238c235be881418b171b75ba785"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f51802e20b196c281ec6e9fe54d5dcb340732238c235be881418b171b75ba785"
    sha256 cellar: :any_skip_relocation, sonoma:        "93bd85e1ac377014f34ba0fd3e41f629d2701bb6186dcae5b12b6670b554cafd"
    sha256 cellar: :any_skip_relocation, ventura:       "93bd85e1ac377014f34ba0fd3e41f629d2701bb6186dcae5b12b6670b554cafd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f51802e20b196c281ec6e9fe54d5dcb340732238c235be881418b171b75ba785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51802e20b196c281ec6e9fe54d5dcb340732238c235be881418b171b75ba785"
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