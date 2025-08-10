class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.150.tgz"
  sha256 "74fbe5a70f3c0cb453a00375152d6595d7015aa43c8931c000948ca319f203d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3d5a726c7d8351ea30f6f394cdb00255233c34ec371593d0e04227339415cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3d5a726c7d8351ea30f6f394cdb00255233c34ec371593d0e04227339415cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d3d5a726c7d8351ea30f6f394cdb00255233c34ec371593d0e04227339415cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7524dc08fb3558a2edfd39fab6d9dc8abf86748c30e0b8c7813000f204ac3da4"
    sha256 cellar: :any_skip_relocation, ventura:       "7524dc08fb3558a2edfd39fab6d9dc8abf86748c30e0b8c7813000f204ac3da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d3d5a726c7d8351ea30f6f394cdb00255233c34ec371593d0e04227339415cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d3d5a726c7d8351ea30f6f394cdb00255233c34ec371593d0e04227339415cd"
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