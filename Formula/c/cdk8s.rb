class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.90.tgz"
  sha256 "c06c6f0fe67b7d6184b694bfe58efb73ef68a43326ffac95fa554128509a7ed1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "081f3da434d2eca2b0f4efdc83fc7d7e800e16893687427016c8650254e6cce3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "081f3da434d2eca2b0f4efdc83fc7d7e800e16893687427016c8650254e6cce3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "081f3da434d2eca2b0f4efdc83fc7d7e800e16893687427016c8650254e6cce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "130f8e54fcb3468910558229ac6f12d3a204766f5f1031331b10c61e0ce47824"
    sha256 cellar: :any_skip_relocation, ventura:       "130f8e54fcb3468910558229ac6f12d3a204766f5f1031331b10c61e0ce47824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "081f3da434d2eca2b0f4efdc83fc7d7e800e16893687427016c8650254e6cce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "081f3da434d2eca2b0f4efdc83fc7d7e800e16893687427016c8650254e6cce3"
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