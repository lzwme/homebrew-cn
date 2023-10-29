require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.159.0.tgz"
  sha256 "e889978e0d4bf8010e2a934eab5edc7e83eca8a9b3a2705c5c722dbaf25a8ec8"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4968c7af7ddf613e34edcb5fc0cf4c83cecb0cfcd6c37472f9114e4bc2659616"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4968c7af7ddf613e34edcb5fc0cf4c83cecb0cfcd6c37472f9114e4bc2659616"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4968c7af7ddf613e34edcb5fc0cf4c83cecb0cfcd6c37472f9114e4bc2659616"
    sha256 cellar: :any_skip_relocation, sonoma:         "95c0abe8ccf020437001b97cb6fb89e5b9b595771509497b4ba0c07f552654a0"
    sha256 cellar: :any_skip_relocation, ventura:        "95c0abe8ccf020437001b97cb6fb89e5b9b595771509497b4ba0c07f552654a0"
    sha256 cellar: :any_skip_relocation, monterey:       "95c0abe8ccf020437001b97cb6fb89e5b9b595771509497b4ba0c07f552654a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4968c7af7ddf613e34edcb5fc0cf4c83cecb0cfcd6c37472f9114e4bc2659616"
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