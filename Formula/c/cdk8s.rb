class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.139.tgz"
  sha256 "b88da9358e5c760d295c6b98213c034f76fa03ca79167d0018d062b2751b7e6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "493f6bd0000064ecf68a90d9f9c66ae69904f157c5b4dd5e54ae4e4930fa6b1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493f6bd0000064ecf68a90d9f9c66ae69904f157c5b4dd5e54ae4e4930fa6b1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "493f6bd0000064ecf68a90d9f9c66ae69904f157c5b4dd5e54ae4e4930fa6b1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7809db9571acfd14d956f4a46d031844e720cf36e85d554ad8d3fe2789047a45"
    sha256 cellar: :any_skip_relocation, ventura:       "7809db9571acfd14d956f4a46d031844e720cf36e85d554ad8d3fe2789047a45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "493f6bd0000064ecf68a90d9f9c66ae69904f157c5b4dd5e54ae4e4930fa6b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493f6bd0000064ecf68a90d9f9c66ae69904f157c5b4dd5e54ae4e4930fa6b1d"
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