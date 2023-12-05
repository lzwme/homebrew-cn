require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.0.tgz"
  sha256 "0b41df235efc3990b9064c37be219e5bd720ee9c706a0ab77453739e2ee12ec5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c6f9f5a9340f592bb28d8816ab3fb5790b67ee2adab13b85d0af8ad64a82b9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c6f9f5a9340f592bb28d8816ab3fb5790b67ee2adab13b85d0af8ad64a82b9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6f9f5a9340f592bb28d8816ab3fb5790b67ee2adab13b85d0af8ad64a82b9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f82a2645cb6c9a3306fc961d010c7bdbba4ea7776522eaca6cacc8ed4751f3c1"
    sha256 cellar: :any_skip_relocation, ventura:        "f82a2645cb6c9a3306fc961d010c7bdbba4ea7776522eaca6cacc8ed4751f3c1"
    sha256 cellar: :any_skip_relocation, monterey:       "f82a2645cb6c9a3306fc961d010c7bdbba4ea7776522eaca6cacc8ed4751f3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6f9f5a9340f592bb28d8816ab3fb5790b67ee2adab13b85d0af8ad64a82b9f"
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