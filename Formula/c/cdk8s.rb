class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.128.tgz"
  sha256 "bc4b4ea66b980f1c91d3c348629a765c04b5687dc40d4b9f929cdc0983837822"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f518a9a70698562d40c7b3a1ad2252113a72df2183502df85aeaeab099d7615e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f518a9a70698562d40c7b3a1ad2252113a72df2183502df85aeaeab099d7615e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f518a9a70698562d40c7b3a1ad2252113a72df2183502df85aeaeab099d7615e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a896a93444c73831663daac214243cf604e15ff91a7ee9195af4126605e2fd"
    sha256 cellar: :any_skip_relocation, ventura:       "b8a896a93444c73831663daac214243cf604e15ff91a7ee9195af4126605e2fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f518a9a70698562d40c7b3a1ad2252113a72df2183502df85aeaeab099d7615e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f518a9a70698562d40c7b3a1ad2252113a72df2183502df85aeaeab099d7615e"
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