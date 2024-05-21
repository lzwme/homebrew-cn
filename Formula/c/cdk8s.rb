require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.123.tgz"
  sha256 "d8d16dcebb68287aaba71e6359abb53b15cb1bc0895720c1bc8ec4a227caa1fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c35aa242b66ce738dd3727f882ea60b5a7e7cf3926eb275ccb627cf16ef6831"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8af16f23915971cf87a68b408aecb2ab28189976b329ce9c05ae5d64ca2e0fe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d052069babfe0ff3b8875936a0bdee54ca4b66c112c24f9e6d51d3f38928d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "610737e7d9f7404867721648aacbb552d49c9a0e5558b77aace09086296f0509"
    sha256 cellar: :any_skip_relocation, ventura:        "e47b62794ef412c73b6ef1c5a573171be051c1c2ff4d945884d02552c75723c1"
    sha256 cellar: :any_skip_relocation, monterey:       "db2754521d8a330e274b6e376c7c6a62a2a1f8bcece20cdc66e6e6972c6f28b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54444b1e82a2b5d12bbf0989531e1e6f68e41ce67440959a7af52e091b116bc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end