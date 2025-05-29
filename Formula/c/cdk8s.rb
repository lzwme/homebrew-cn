class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.83.tgz"
  sha256 "ba8ce6c8ecab030907a3fd949e50be3011fc92eed4445b4d8f52cdef5f6495ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf509675e0eda79a48d1b3b61292dc41fb58f854bcf76118719e66eb64fc0935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf509675e0eda79a48d1b3b61292dc41fb58f854bcf76118719e66eb64fc0935"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf509675e0eda79a48d1b3b61292dc41fb58f854bcf76118719e66eb64fc0935"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff12cf8938042948d5f7c0ec6326411194668a1aa471a682481f2bc18a3af731"
    sha256 cellar: :any_skip_relocation, ventura:       "ff12cf8938042948d5f7c0ec6326411194668a1aa471a682481f2bc18a3af731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf509675e0eda79a48d1b3b61292dc41fb58f854bcf76118719e66eb64fc0935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf509675e0eda79a48d1b3b61292dc41fb58f854bcf76118719e66eb64fc0935"
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