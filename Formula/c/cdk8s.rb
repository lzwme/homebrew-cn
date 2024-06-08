require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.139.tgz"
  sha256 "d4c5ece134112caeff2441b41bff13b76f5657a394603eacd6796c5deb8cec49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aac752eb6cb76a5966f18e698bb025b19cf9f1cd7982122d055a249ca1c83cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aac752eb6cb76a5966f18e698bb025b19cf9f1cd7982122d055a249ca1c83cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aac752eb6cb76a5966f18e698bb025b19cf9f1cd7982122d055a249ca1c83cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6d071fb1f9f14b405a486e806f5f6628a4b49194a2661b0f6958b758875636f"
    sha256 cellar: :any_skip_relocation, ventura:        "e6d071fb1f9f14b405a486e806f5f6628a4b49194a2661b0f6958b758875636f"
    sha256 cellar: :any_skip_relocation, monterey:       "e6d071fb1f9f14b405a486e806f5f6628a4b49194a2661b0f6958b758875636f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdb94bc2ab32b86523cc0dfd9188e7f32b17293ec2eba76ac52f098503c1a1ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end