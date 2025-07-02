class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.117.tgz"
  sha256 "ba4530f0ae0e4bba3b0a3e231b9446cf58138f326f9e397fd8b621eec1321427"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb2593dc6a716cf252ba599abc342ecd2a90c6eb5266b8976091f55649cfb33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcb2593dc6a716cf252ba599abc342ecd2a90c6eb5266b8976091f55649cfb33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcb2593dc6a716cf252ba599abc342ecd2a90c6eb5266b8976091f55649cfb33"
    sha256 cellar: :any_skip_relocation, sonoma:        "254257f7114b082667ca3310d80e2ff12d0ff33ebc0ca42c4c446b976f522db8"
    sha256 cellar: :any_skip_relocation, ventura:       "254257f7114b082667ca3310d80e2ff12d0ff33ebc0ca42c4c446b976f522db8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb2593dc6a716cf252ba599abc342ecd2a90c6eb5266b8976091f55649cfb33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb2593dc6a716cf252ba599abc342ecd2a90c6eb5266b8976091f55649cfb33"
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