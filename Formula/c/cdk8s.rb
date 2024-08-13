class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.187.tgz"
  sha256 "f094b561fbccc44a46c906f680bd2b0ccead5acfe2919fc5fcfcd89e3165a95a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fc6cd1b3234aacb22be917bf910a2f84e13b636d7558fd306c6c7154575c062"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fc6cd1b3234aacb22be917bf910a2f84e13b636d7558fd306c6c7154575c062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fc6cd1b3234aacb22be917bf910a2f84e13b636d7558fd306c6c7154575c062"
    sha256 cellar: :any_skip_relocation, sonoma:         "64d1ea2e58be1af5fb448babb16da1cd75cb696f41c8d0ede4fb1fcccba29d05"
    sha256 cellar: :any_skip_relocation, ventura:        "64d1ea2e58be1af5fb448babb16da1cd75cb696f41c8d0ede4fb1fcccba29d05"
    sha256 cellar: :any_skip_relocation, monterey:       "64d1ea2e58be1af5fb448babb16da1cd75cb696f41c8d0ede4fb1fcccba29d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc6cd1b3234aacb22be917bf910a2f84e13b636d7558fd306c6c7154575c062"
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