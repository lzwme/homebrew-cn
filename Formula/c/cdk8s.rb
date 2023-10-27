require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.157.0.tgz"
  sha256 "23857bf4db6839ac59396eb4f9784b6e10405abaaca7a72c4a7cdfde77566cc9"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0772749371f815a125cb74b644199e64a02e10f2f25a7ae2f4e46cbd5f4dc044"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0772749371f815a125cb74b644199e64a02e10f2f25a7ae2f4e46cbd5f4dc044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0772749371f815a125cb74b644199e64a02e10f2f25a7ae2f4e46cbd5f4dc044"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2bc08fc1b18210fb3cbf4b163a7dbde4b6bee4ce1d958ae3cd678cf72ed1ff6"
    sha256 cellar: :any_skip_relocation, ventura:        "e2bc08fc1b18210fb3cbf4b163a7dbde4b6bee4ce1d958ae3cd678cf72ed1ff6"
    sha256 cellar: :any_skip_relocation, monterey:       "e2bc08fc1b18210fb3cbf4b163a7dbde4b6bee4ce1d958ae3cd678cf72ed1ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0772749371f815a125cb74b644199e64a02e10f2f25a7ae2f4e46cbd5f4dc044"
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