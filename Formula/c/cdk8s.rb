require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.143.0.tgz"
  sha256 "4d375005e1fae1f4fd092ff82f481cbf1e2fea1187af88f26e005d2ac4deb7f1"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a9a35dbb0136252047ac1c1a26bb45bbd7669d5781b4fa71336b16b92a971e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a9a35dbb0136252047ac1c1a26bb45bbd7669d5781b4fa71336b16b92a971e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a9a35dbb0136252047ac1c1a26bb45bbd7669d5781b4fa71336b16b92a971e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "24f5c9b2f353a710cbe20e09619e135cb971e53cafbd9a02d8eaf01d736f48a2"
    sha256 cellar: :any_skip_relocation, ventura:        "24f5c9b2f353a710cbe20e09619e135cb971e53cafbd9a02d8eaf01d736f48a2"
    sha256 cellar: :any_skip_relocation, monterey:       "24f5c9b2f353a710cbe20e09619e135cb971e53cafbd9a02d8eaf01d736f48a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a9a35dbb0136252047ac1c1a26bb45bbd7669d5781b4fa71336b16b92a971e5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end