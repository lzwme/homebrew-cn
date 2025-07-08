class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.123.tgz"
  sha256 "f1072d8bc09cc28d9a866dbde3d2df8e8d75d02f90f00d1799748915473e11b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f15062f4944d9979da20b8bd5e759f30a55a78edce5e8ffa56effbc577d387b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f15062f4944d9979da20b8bd5e759f30a55a78edce5e8ffa56effbc577d387b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f15062f4944d9979da20b8bd5e759f30a55a78edce5e8ffa56effbc577d387b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d6ba048664a315d24e08836ee42194ed0f02aca70a98ac9f182ba54d5344494"
    sha256 cellar: :any_skip_relocation, ventura:       "6d6ba048664a315d24e08836ee42194ed0f02aca70a98ac9f182ba54d5344494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f15062f4944d9979da20b8bd5e759f30a55a78edce5e8ffa56effbc577d387b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f15062f4944d9979da20b8bd5e759f30a55a78edce5e8ffa56effbc577d387b"
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