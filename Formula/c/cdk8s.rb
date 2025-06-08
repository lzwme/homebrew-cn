class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.93.tgz"
  sha256 "3c1d1bbc49dda1d4241cd790698e717a5b66f67600a78f26d2e999299a84587a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "534134adbf8a7b1231a51e918e390e58d9a483212cfcd6db0e79fcad86327e11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "534134adbf8a7b1231a51e918e390e58d9a483212cfcd6db0e79fcad86327e11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "534134adbf8a7b1231a51e918e390e58d9a483212cfcd6db0e79fcad86327e11"
    sha256 cellar: :any_skip_relocation, sonoma:        "35bacc38d6cca94d6e3f130b907234a62e704ee04e773e58d781adb97a7f6cf2"
    sha256 cellar: :any_skip_relocation, ventura:       "35bacc38d6cca94d6e3f130b907234a62e704ee04e773e58d781adb97a7f6cf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "534134adbf8a7b1231a51e918e390e58d9a483212cfcd6db0e79fcad86327e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "534134adbf8a7b1231a51e918e390e58d9a483212cfcd6db0e79fcad86327e11"
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