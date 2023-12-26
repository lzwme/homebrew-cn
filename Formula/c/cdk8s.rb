require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.19.tgz"
  sha256 "643b70fe5c1740a55cee3ca2c8c497544c2aa93c2076aa0c1672155ec7f1b801"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "760daf598c50fd140196734af833d21d15efd6678a3b699f681977760816294a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "760daf598c50fd140196734af833d21d15efd6678a3b699f681977760816294a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "760daf598c50fd140196734af833d21d15efd6678a3b699f681977760816294a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b59f338038b54a0672022cbf21a416ae9a3e0d9abc9f659c705310ece713ecf"
    sha256 cellar: :any_skip_relocation, ventura:        "0b59f338038b54a0672022cbf21a416ae9a3e0d9abc9f659c705310ece713ecf"
    sha256 cellar: :any_skip_relocation, monterey:       "0b59f338038b54a0672022cbf21a416ae9a3e0d9abc9f659c705310ece713ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "760daf598c50fd140196734af833d21d15efd6678a3b699f681977760816294a"
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