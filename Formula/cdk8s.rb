require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.15.0.tgz"
  sha256 "ae063ea8f203f7a734f85864c6945a3fd026ff15031ea7068cf9c89fad53eb92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "984e57971575c0666dfe409cfac1c64bc125b3252a26c52e994d1948f2d9b9c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "984e57971575c0666dfe409cfac1c64bc125b3252a26c52e994d1948f2d9b9c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "984e57971575c0666dfe409cfac1c64bc125b3252a26c52e994d1948f2d9b9c8"
    sha256 cellar: :any_skip_relocation, ventura:        "f64e0c708618116810992361dbe10646b6dd6b59fabad7e4decee920fd02ce87"
    sha256 cellar: :any_skip_relocation, monterey:       "f64e0c708618116810992361dbe10646b6dd6b59fabad7e4decee920fd02ce87"
    sha256 cellar: :any_skip_relocation, big_sur:        "f64e0c708618116810992361dbe10646b6dd6b59fabad7e4decee920fd02ce87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a287269724e4a3cb21cfb8674d10ba511ef98ae67202deb334fd03c8b9c1c28"
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