require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.165.0.tgz"
  sha256 "905a0bb18424589da58623b52c9c4a1ae7bb0e4ccd586a1d732f7216c7cf8df4"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e75e6b8abe4a6ef671c89c33fcfa5dadff181fe8eca1ac61b23a0e1a189233c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e75e6b8abe4a6ef671c89c33fcfa5dadff181fe8eca1ac61b23a0e1a189233c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e75e6b8abe4a6ef671c89c33fcfa5dadff181fe8eca1ac61b23a0e1a189233c"
    sha256 cellar: :any_skip_relocation, sonoma:         "90c80f4545aac3ebef7bc5f52f07d29e76fd63da8f79b439ccf1ce0aa082a663"
    sha256 cellar: :any_skip_relocation, ventura:        "90c80f4545aac3ebef7bc5f52f07d29e76fd63da8f79b439ccf1ce0aa082a663"
    sha256 cellar: :any_skip_relocation, monterey:       "90c80f4545aac3ebef7bc5f52f07d29e76fd63da8f79b439ccf1ce0aa082a663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e75e6b8abe4a6ef671c89c33fcfa5dadff181fe8eca1ac61b23a0e1a189233c"
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