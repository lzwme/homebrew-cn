require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.118.tgz"
  sha256 "adbbaa88c23b96f5cde4af8346936f7ccd5520418051879561b790f90813133a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5540652388fbcef0f3e7f77ca140e488e9a97fce63ab876d3827e04f5e52012"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef678940ea56ce7cceb812c67481d5c3b24d6d877aee690ecf4a7182a44d8028"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d26dee52b8f4932a1b87d6401fc1c834c9e5936d8bb3f315cd57584789905210"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cd86a77b4f5ecd2b37884450d375b3f0373f991197a28a294cd50a06fbd6eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "f30a2d12179200086cd302a65a40f44738f6345f6f87c21104da2821d32ba653"
    sha256 cellar: :any_skip_relocation, monterey:       "6fdc4ed03d365daa51f079e1566e7c53a9c7d3bc5fbe990d540afb39fd9f87c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba828c9d0ccff6ca3eeb59bbff64026feb16ce0475cc10f7ddbe665c53bb180"
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