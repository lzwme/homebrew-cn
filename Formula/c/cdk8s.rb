require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.59.tgz"
  sha256 "ac809730ba445fd5c5f2ad894b63806d537a1ef7812e5c0c41c58d1b625cda04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "413740e91dd445981591e58cd84ee5af84776a3ce6b984490a2e42b9fe8947e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "413740e91dd445981591e58cd84ee5af84776a3ce6b984490a2e42b9fe8947e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "413740e91dd445981591e58cd84ee5af84776a3ce6b984490a2e42b9fe8947e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2795f660cba65e5b2fac03bbfd4b24f8ba27a5a950a62e6f3967a2792aa15f9"
    sha256 cellar: :any_skip_relocation, ventura:        "a2795f660cba65e5b2fac03bbfd4b24f8ba27a5a950a62e6f3967a2792aa15f9"
    sha256 cellar: :any_skip_relocation, monterey:       "a2795f660cba65e5b2fac03bbfd4b24f8ba27a5a950a62e6f3967a2792aa15f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "413740e91dd445981591e58cd84ee5af84776a3ce6b984490a2e42b9fe8947e1"
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