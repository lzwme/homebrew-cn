require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.60.tgz"
  sha256 "cbf22b506f5dce96561a7b7770cb4bf7a40e5096d873da76907f264cb8d1f215"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02936057f94866676fddfaaa24dd3dd8082ae03a4950eee9f08017ab2d492fce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02936057f94866676fddfaaa24dd3dd8082ae03a4950eee9f08017ab2d492fce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02936057f94866676fddfaaa24dd3dd8082ae03a4950eee9f08017ab2d492fce"
    sha256 cellar: :any_skip_relocation, sonoma:         "26a54f24b0cb25a067b52d4a0ba02cadb59327a0efd6f150fe88193b2f05bc24"
    sha256 cellar: :any_skip_relocation, ventura:        "26a54f24b0cb25a067b52d4a0ba02cadb59327a0efd6f150fe88193b2f05bc24"
    sha256 cellar: :any_skip_relocation, monterey:       "26a54f24b0cb25a067b52d4a0ba02cadb59327a0efd6f150fe88193b2f05bc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02936057f94866676fddfaaa24dd3dd8082ae03a4950eee9f08017ab2d492fce"
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