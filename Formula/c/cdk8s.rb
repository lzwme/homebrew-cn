class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.129.tgz"
  sha256 "9fa4e5a24bbab04c4d838417fa38fe3204edd19fc35dd2a082ba0191b307a25e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a38d0bfeff73be6999198a150c4842a6fd9202322363f535b2a6a0566cc6c9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a38d0bfeff73be6999198a150c4842a6fd9202322363f535b2a6a0566cc6c9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a38d0bfeff73be6999198a150c4842a6fd9202322363f535b2a6a0566cc6c9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "217f598369554b10866dfa7f8ccf868f69d0e309976d3d3cae3035cd32bc4c08"
    sha256 cellar: :any_skip_relocation, ventura:       "217f598369554b10866dfa7f8ccf868f69d0e309976d3d3cae3035cd32bc4c08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a38d0bfeff73be6999198a150c4842a6fd9202322363f535b2a6a0566cc6c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a38d0bfeff73be6999198a150c4842a6fd9202322363f535b2a6a0566cc6c9a"
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