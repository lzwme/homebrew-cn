class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.229.tgz"
  sha256 "fb10620dca9ce2e51ec610677ab584b3ef6fcbc6bf00aad06f72b389ebfa7593"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24b510561c0d827d52316846a3c06df596416b2bfd0b3f33ef5812df2f34c13b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24b510561c0d827d52316846a3c06df596416b2bfd0b3f33ef5812df2f34c13b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24b510561c0d827d52316846a3c06df596416b2bfd0b3f33ef5812df2f34c13b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5882314e9c92f0af1cf812f6cde99c7730d21291312d0068814acd0112f5a37"
    sha256 cellar: :any_skip_relocation, ventura:       "f5882314e9c92f0af1cf812f6cde99c7730d21291312d0068814acd0112f5a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24b510561c0d827d52316846a3c06df596416b2bfd0b3f33ef5812df2f34c13b"
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